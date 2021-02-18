//
//  ViewController.m
//  LSKVO
//
//  Created by lhs7248 on 2018/4/9.
//  Copyright © 2018年 lhs7248. All rights reserved.
//

#import "ViewController.h"
#import "LSPerson.h"
#import "NSObject+IMPKVO.h"
@interface ViewController ()

@property (nonatomic, strong) LSPerson * person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LSPerson * pesrson = [[LSPerson alloc]init];
    
//    [pesrson setValue:@"liliang" forKey:@"name"];
    
    self.person = pesrson;
    
    
    pesrson.age = @"12";
    

//    [self addKVO];
    [self addCumtomKVO];

}

- (void)addCumtomKVO{
    [self.person ls_addObserver:self forKeyPath:@"name" callBack:^(id  _Nullable observedObject, NSString * _Nullable observedKey, id  _Nullable oldValue, id  _Nullable newValue) {
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.person.name = @"liliang";
    
    });
}

- (void)addKVO{
    
    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.person.name = @"liliang";
        self.person.age = @"11";
    });
    
    [self.person removeObserver:self forKeyPath:@"name"];


}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
