//
//  LSViewF.m
//  LSTouchEventSample
//
//  Created by lhs7248 on 2021/1/8.
//

#import "LSViewF.h"

@implementation LSViewF

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
//    [self printResponderChain];
}

- (void)printResponderChain
{
    UIResponder *responder = self;
    printf("%s",[NSStringFromClass([responder class]) UTF8String]);
    while (responder.nextResponder) {
        responder = responder.nextResponder;
        printf(" --> %s",[NSStringFromClass([responder class]) UTF8String]);
    }
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
