//
//  NSObject+IMPKVO.m
//  LSKVO
//
//  Created by lhs7248 on 2018/4/10.
//  Copyright © 2018年 lhs7248. All rights reserved.
//
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+IMPKVO.h"

NSString *const LSObservers = @"LSObservers";

NSString *const LSKVOIMP = @"LSKVOIMP";

@interface LSObserverInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) LSObserverCallBack block;

@end

@implementation LSObserverInfo

- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)keyPath callBack:(LSObserverCallBack)callBack
{
    self = [super init];
    if (self) {
        _observer = observer;
        _keyPath = keyPath;
        _block = callBack;
    }
    return self;
}

@end




@interface NSObject ()
@property (nonatomic, strong) NSMutableArray * observers;
@end


@implementation NSObject (IMPKVO)




/**添加观察者
 */
- (void)ls_addObserver:(NSObject *_Nullable)observer forKeyPath:(NSString *_Nonnull)keyPath callBack:(LSObserverCallBack _Nullable )callBack{
    
    
    SEL setterSelector = NSSelectorFromString(getSetterWithGetter(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@", self, keyPath];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);
    
    // 如果不是KVOIMP的class 则创建子class
    if (![clazzName hasPrefix:LSKVOIMP]) {
        clazz = [self makeKVOClassWithOriginClassName:clazzName];
        object_setClass(self, clazz);
    }
    
    // add our kvo setter if this class (not superclasses) doesn't implement the setter?
    // 如果该类没有实现KVO的setter方法，则添加我们自己的KVO的实现
    if (![self hasSelecotor:setterSelector]) {
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, setterSelector, (IMP)KVOIMP_setter, types);
    }
    
    LSObserverInfo *info = [[LSObserverInfo alloc]initWithObserver:observer Key:keyPath callBack:callBack];
    

    if (self.observers == nil) {
        self.observers = [[NSMutableArray alloc]init];
    }
    [self.observers addObject:info];
    
 
    
}



#pragma mark - Overridden Methods
static void KVOIMP_setter(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superclazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    // cast our pointer so the compiler won't complain
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // call super's setter, which is original class's setter method
    objc_msgSendSuperCasted(&superclazz, _cmd, newValue);
    
    // 找到KVO的实现
    NSMutableArray *observers = objc_getAssociatedObject(self, &LSObservers);
    for (LSObserverInfo *each in observers) {
        if ([each.keyPath isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                each.block(self, getterName, oldValue, newValue);
            });
        }
    }
    
  
    
}

/**查看是否实现了keyPath的setter方法
 */
- (BOOL)implementSetterSelector:(NSString *)keyPath{
    
    SEL setterSelector = NSSelectorFromString(getSetterWithGetter(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (setterMethod) {
        return YES;
    }
    return NO;
}




/**移除观察者
 */
- (void)ls_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    
    LSObserverInfo * observerInfo = nil;
    
    for (LSObserverInfo * observInfo in self.observers) {
        
        if (observInfo.observer == observer && [observInfo.keyPath isEqualToString:keyPath]) {
            observerInfo = observInfo;
            break;
        }
    }
    
    [self.observers removeObject:observerInfo];
    
}

/**创建KVO实现的中间类
 */
- (Class)makeKVOClassWithOriginClassName:(NSString *)originClassName{
    
    NSString *KVOClassName = [LSKVOIMP stringByAppendingString:originClassName];
    Class LSClass = NSClassFromString(KVOClassName);
    
    if (LSClass) {
        return LSClass;
    }
    
    // class doesn't exist yet, make it
    Class originalClass = object_getClass(self);
    Class LSKVOClass = objc_allocateClassPair(originalClass, KVOClassName.UTF8String, 0);
    
    // grab class method's signature so we can borrow it
    Method clazzMethod = class_getInstanceMethod(originalClass, @selector(class));
    const char *types = method_getTypeEncoding(clazzMethod);
    class_addMethod(LSKVOClass, @selector(class), (IMP)LSKVO_class, types);
    
    objc_registerClassPair(LSKVOClass);
    
    return LSKVOClass;
}


static Class LSKVO_class(id self, SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));
}



/**根据setter方法获取get的key值
 */
static NSString * getterForSetter(NSString *setter)
{
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    // 获取set 和：之间的字符串
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *keyPath = [setter substringWithRange:range];
    
    // lower case the first letter
    NSString *firstLetter = [[keyPath substringToIndex:1] lowercaseString];
    keyPath = [keyPath stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return keyPath;
}


/**获取 属性的setter方法字符串
 */
static NSString * getSetterWithGetter(NSString *getter)
{
    if (getter.length <= 0) {
        return nil;
    }
    
    // getter的首字母大写 name变成 Name
    NSString *uppTextStr = [[getter substringToIndex:1] uppercaseString];
    NSString *remainTextStr = [getter substringFromIndex:1];
    
    // 最终为setName:
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", uppTextStr, remainTextStr];
    
    return setter;
}


/**获取所有的class Method方法
 */
static NSArray *getAllClassMethodName(Class c)
{
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(c, &methodCount);
    unsigned int i;
    for(i = 0; i < methodCount; i++) {
        [array addObject: NSStringFromSelector(method_getName(methodList[i]))];
    }
    free(methodList);
    
    return array;
}


/**判断某个类是否包含selector 方法
 */
- (BOOL)hasSelecotor:(SEL)selector {
    
    Class tempClass = object_getClass(self);
    
    
    unsigned int methodAmount =  0;
    
    Method * tempClassMethod =  class_copyMethodList(tempClass, &methodAmount);
    
    for (unsigned int i = 0 ; i < methodAmount; i++) {
        
        SEL currentSelector = method_getName(tempClassMethod[i]);
        if (currentSelector == selector) {
            free(currentSelector);
            return YES;
        }
    }
    free(tempClassMethod);
    return NO;
}




/** 为IMPKVO 新增属性 用来存储observers
 */
-(void)setObservers:(NSMutableArray *)observers{
    
    objc_setAssociatedObject(self, &LSObservers, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableArray *)observers{
 
    return objc_getAssociatedObject(self, &LSObservers);
}



@end
