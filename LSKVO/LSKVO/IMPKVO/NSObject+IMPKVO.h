//
//  NSObject+IMPKVO.h
//  LSKVO
//
//  Created by lhs7248 on 2018/4/10.
//  Copyright © 2018年 lhs7248. All rights reserved.
//

#import <Foundation/Foundation.h>


/**添加观察者的回调
 */
typedef void(^LSObserverCallBack)(id _Nullable observedObject, NSString * _Nullable observedKey, id _Nullable oldValue, id _Nullable newValue);


@interface NSObject (IMPKVO)

/**添加观察者
 */
- (void)ls_addObserver:(NSObject *_Nullable)observer forKeyPath:(NSString *_Nonnull)keyPath callBack:(LSObserverCallBack _Nullable )callBack;


/**移除观察者
 */
- (void)ls_removeObserver:(NSObject *_Nullable)observer forKeyPath:(NSString *_Nullable)keyPath;

@end
