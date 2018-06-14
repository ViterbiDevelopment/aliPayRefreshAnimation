//
//  animationView.m
//  aliPayAnimation
//
//  Created by 掌上先机 on 2017/7/18.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "animationView.h"


@interface animationView()<CAAnimationDelegate>

@property(nonatomic,strong)CAShapeLayer *maskLayer;

@property(nonatomic,strong)CAShapeLayer *letfEye;

@property(nonatomic,strong)CAShapeLayer *rightEye;

@property(nonatomic,strong)CAShapeLayer *runDot;

@end

@implementation animationView


-(void)begin{
  
    [_rightEye removeFromSuperlayer];
    [_letfEye removeFromSuperlayer]; ;
    [_maskLayer removeFromSuperlayer];
   
   
    CAShapeLayer *shaper = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat x = 50;
    CGFloat y = 60;
    
    [path addArcWithCenter:CGPointMake(x, y) radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path stroke];
    shaper.lineWidth = 2;
    shaper.strokeColor = [UIColor redColor].CGColor;
    shaper.fillColor = [UIColor clearColor].CGColor;
    shaper.path = path.CGPath;
  
    _runDot = shaper;
  
    [self.layer addSublayer:shaper];
    CAKeyframeAnimation *keyAnmations = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnmations.duration = 1;
    keyAnmations.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, -10) radius:10 startAngle:M_PI/2.0 endAngle:M_PI/2.0 + 2*M_PI clockwise:YES].CGPath;
    keyAnmations.delegate = self;
    
    keyAnmations.removedOnCompletion = NO;
    
    keyAnmations.fillMode = kCAFillModeForwards;
    
    [keyAnmations setValue:@"runAnimation" forKey:@"animationName"];
    [shaper addAnimation:keyAnmations forKey:nil];
}

-(void)animationDidStart:(CAAnimation *)anim{

    //runAnimation
    
    if ([[anim valueForKey:@"animationName"] isEqualToString:@"runAnimation"]) {
      
        [self performSelector:@selector(drawLeftEye) withObject:nil afterDelay:0.25 + 1.0/8];
        [self performSelector:@selector(drawRightEye) withObject:nil afterDelay:0.25 + 0.25 + 1.0/8];
        [self performSelector:@selector(drawSmile) withObject:nil afterDelay:0.25 + 0.25 + 0.25];
        [self performSelector:@selector(begainSmileEndAimation) withObject:nil afterDelay:0.25 + 0.25 + 0.25 + 0.5];
        [self performSelector:@selector(hiddenLeftEye) withObject:nil afterDelay:0.5 + 0.25 + 0.5 + 1.0/8];
        [self performSelector:@selector(hiddenRightEye) withObject:nil afterDelay:0.5 + 0.25 + 0.5 + 1.0/8 + 0.25];
    }
  
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if ([[anim valueForKey:@"animationName"] isEqualToString:@"smileBeginAniamtion"]) {
        
            [self maskLayerTransformRation];
    }
    
    // smileEndAniamtion
    
    if ([[anim valueForKey:@"animationName"] isEqualToString:@"smileEndAniamtion"]) {
        [self begin];
    }
}

-(void)maskLayerTransformRation{
  
    CABasicAnimation *BasicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    BasicAnimation.toValue=@(M_PI/2.0);
    BasicAnimation.duration=0.25;
    
    BasicAnimation.fillMode = kCAFillModeForwards;
    
    BasicAnimation.removedOnCompletion = NO;
    
    BasicAnimation.repeatCount = NO;
    [_maskLayer addAnimation:BasicAnimation forKey:nil];

}

-(void)hiddenLeftEye{

    [_letfEye removeFromSuperlayer];
}

-(void)hiddenRightEye{

    [_rightEye removeFromSuperlayer];
}

-(void)drawSmile{

    [_runDot removeFromSuperlayer];
    CAShapeLayer *smile = [self createFullSmile];
    _maskLayer = smile;
    _maskLayer.strokeStart = 0;
    _maskLayer.strokeEnd = 1;
    [_maskLayer addAnimation:[self smileBeginAniamtion] forKey:nil];
}

-(CAShapeLayer *)createFullSmile{

    CAShapeLayer *shaper = [CAShapeLayer layer];
    shaper.frame = self.layer.bounds;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(50, 50) radius:10 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path stroke];
    shaper.lineWidth = 2;
    shaper.strokeColor = [UIColor redColor].CGColor;
    shaper.fillColor = [UIColor clearColor].CGColor;
    shaper.path = path.CGPath;
    [self.layer addSublayer:shaper];
    return shaper;
}

-(void)drawRightEye{
    CAShapeLayer *twoDot = [self createTwoDot];
    _rightEye = twoDot;
    [self.layer addSublayer:twoDot];
    
}

-(void)drawLeftEye{
    
    CAShapeLayer *oneDot = [self createOneDot];
    _letfEye = oneDot;
    [self.layer addSublayer:oneDot];
}


-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        CAShapeLayer *smile = [self createSmile];
        _maskLayer = smile;
      
        CAShapeLayer *oneDot = [self createOneDot];
        _letfEye = oneDot;
        [self.layer addSublayer:oneDot];
        CAShapeLayer *twoDot = [self createTwoDot];
        
        _rightEye = twoDot;
        
        [self.layer addSublayer:twoDot];
    }
    return self;

}

-(void)begainSmileEndAimation{
    _maskLayer.strokeStart = 1;
    [_maskLayer addAnimation:[self smileEndAniamtion] forKey:nil];
}

-(CABasicAnimation *)smileEndAniamtion{

    CABasicAnimation *anmiation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    [anmiation setValue:@"smileEndAniamtion" forKey:@"animationName"];
    anmiation.delegate = self;
    anmiation.fromValue = @(0);
    anmiation.duration = 1;
    return anmiation;
}

-(CABasicAnimation *)smileBeginAniamtion{

    CABasicAnimation *anmiation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [anmiation setValue:@"smileBeginAniamtion" forKey:@"animationName"];
    anmiation.delegate = self;
    anmiation.fromValue = @(0);
    anmiation.duration = 1;
    return anmiation;
}


-(CAShapeLayer *)createTwoDot{

    CAShapeLayer *shaper = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat radious = sqrt(pow(50, 2)*2);
    CGFloat y = (radious - 10) * sin(M_PI/4.0);
    CGFloat x = (radious - 10) * cos(M_PI/4.0) + 10 * sin(M_PI_4) * 2;
    [path addArcWithCenter:CGPointMake(x, y) radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path stroke];
    shaper.lineWidth = 2;
    shaper.strokeColor = [UIColor redColor].CGColor;
    shaper.fillColor = [UIColor clearColor].CGColor;
    shaper.path = path.CGPath;
    return shaper;
}

-(CAShapeLayer *)createOneDot{

    CAShapeLayer *shaper = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat radious = sqrt(pow(50, 2)*2);
    CGFloat x = (radious - 10) * cos(M_PI_4);
    CGFloat y = (radious - 10) * sin(M_PI_4);
    
    [path addArcWithCenter:CGPointMake(x, y) radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path stroke];
    shaper.lineWidth = 2;
    shaper.strokeColor = [UIColor redColor].CGColor;
    shaper.fillColor = [UIColor clearColor].CGColor;
    shaper.path = path.CGPath;
    return shaper;
}

-(CAShapeLayer *)createSmile{
    CAShapeLayer *shaper = [CAShapeLayer layer];
    shaper.strokeStart = 0;
    shaper.strokeEnd = 1;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(50, 50) radius:10 startAngle:0 endAngle:M_PI clockwise:YES];
    [path stroke];
    shaper.lineWidth = 2;
    shaper.strokeColor = [UIColor redColor].CGColor;
    shaper.fillColor = [UIColor clearColor].CGColor;
    shaper.path = path.CGPath;
    
    [self.layer addSublayer:shaper];
    return shaper;
}



@end
