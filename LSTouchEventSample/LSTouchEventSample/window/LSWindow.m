//
//  LSWindow.m
//  LSTouchEventSample
//
//  Created by lhs7248 on 2021/1/11.
//

#import "LSWindow.h"

@implementation LSWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}
-(instancetype)init{
    self = [super init];
    
    return self;
}
-(void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    
    
    
}

@end
