//
//  LSViewA.m
//  LSTouchEventSample
//
//  Created by lhs7248 on 2021/1/8.
//

#import "LSViewA.h"

@implementation LSViewA

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{

    
    NSLog(@"%@--%s",NSStringFromClass([self class]),__func__);
    UIView * view = [super hitTest:point withEvent:event];
    

    return view;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"%@--%s",NSStringFromClass([self class]),__func__);
    return [super pointInside:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@--%s",NSStringFromClass([self class]),__func__);
    [super touchesEnded:touches withEvent:event];
    
    
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@--%s",NSStringFromClass([self class]),__func__);
    [super touchesEnded:touches withEvent:event];
   
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@--%s",NSStringFromClass([self class]),__func__);
    [super touchesEnded:touches withEvent:event];
   
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"%@--%s",NSStringFromClass([self class]),__func__);
    [super touchesEnded:touches withEvent:event];
    
}

@end
