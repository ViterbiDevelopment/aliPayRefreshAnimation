//
//  ViewController.m
//  aliPayAnimation
//
//  Created by 掌上先机 on 2017/7/18.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "ViewController.h"
#import "animationView.h"


@interface ViewController ()


@property(nonatomic,strong)animationView *animation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    animationView *animation = [[animationView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    
    _animation = animation;
    
    animation.center = self.view.center;
    
    
    
    [self.view addSubview:animation];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)begin:(id)sender {
    
    
    [_animation begin];
    
    
    
    
    
    
}



@end
