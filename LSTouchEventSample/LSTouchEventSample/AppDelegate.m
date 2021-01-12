//
//  AppDelegate.m
//  LSTouchEventSample
//
//  Created by lhs7248 on 2021/1/8.
//

#import "AppDelegate.h"
#import "LSWindow.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    LSWindow * window = [[LSWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    window.backgroundColor = [UIColor whiteColor];
    
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController * vc = [storyboard instantiateInitialViewController];
    
    window.rootViewController = vc;
    
    self.window = window;
    
    [window makeKeyAndVisible];
    
    

    return YES;
}




@end
