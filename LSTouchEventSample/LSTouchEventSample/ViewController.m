//
//  ViewController.m
//  LSTouchEventSample
//
//  Created by lhs7248 on 2021/1/8.
//

#import "ViewController.h"
#import "LSViewA.h"
#import "LSViewB.h"
#import "LSViewC.h"
#import "LSViewD.h"
#import "LSViewE.h"
#import "LSViewF.h"
#import "LSView.h"
@interface ViewController ()

@end

@implementation ViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.view = [[LSView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.view = [[LSView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view.
    
    [self addSubViews];
}
- (void)addSubViews
{
    CGSize  screenSize = UIScreen.mainScreen.bounds.size;
    LSViewA * viewA = [[LSViewA alloc]initWithFrame:CGRectMake(40,80,screenSize.width - 60, 300)];
    viewA.backgroundColor = UIColor.yellowColor;
    
    
    
    LSViewB * viewB = [[LSViewB alloc]initWithFrame:CGRectMake(20,40,screenSize.width - 120, 180)];
    viewB.backgroundColor = UIColor.blueColor;
    
    [viewA addSubview:viewB];
    
    
    [self.view addSubview:viewA];
    
    
    
    LSViewD * viewD = [[LSViewD alloc]initWithFrame:CGRectMake(40,400,screenSize.width - 60, 300)];
    viewD.backgroundColor = UIColor.grayColor;
    
    LSViewE * viewE = [[LSViewE alloc]initWithFrame:CGRectMake(20,20,screenSize.width - 120, 100)];
    viewE.backgroundColor = UIColor.redColor;
    
    [viewD addSubview:viewE];
    
    LSViewF * viewF = [[LSViewF alloc]initWithFrame:CGRectMake(20,140,screenSize.width - 120, 100)];
    viewF.backgroundColor = UIColor.orangeColor;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    
    [viewF addGestureRecognizer:tap];
    
    
    
    [viewD addSubview:viewF];
    
    [self.view addSubview:viewD];
    
}

- (void)clickAction:(UITapGestureRecognizer *)sender
{
    
}


@end
