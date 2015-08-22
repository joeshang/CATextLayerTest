//
//  ViewController.m
//  CATextLayerTest
//
//  Created by Joe Shang on 7/14/15.
//  Copyright (c) 2015 Shang Chuanren. All rights reserved.
//

#import "ViewController.h"

static CGFloat const kTextLayerFontSize = 29.0f;
static CGFloat const kLayerWidth = 300.0f;
static CGFloat const kLayerHeight = 40.0f;
static CGFloat const kAnimationDuration = 5.0f;

@interface ViewController ()

@property (nonatomic, strong) CATextLayer *colorTextLayer;
@property (nonatomic, strong) CATextLayer *maskTextLayer;
@property (nonatomic, strong) CALayer *topLayer;
@property (nonatomic, strong) CALayer *bottomLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorTextLayer = [CATextLayer layer];
    self.colorTextLayer.string = @"我会整体变色哦";
    [self p_commonInitTextLayer:self.colorTextLayer];
    [self.view.layer addSublayer:self.colorTextLayer];
    
    self.topLayer = [CALayer layer];
    self.topLayer.backgroundColor = [UIColor blueColor].CGColor;
    self.topLayer.frame = CGRectMake(0, 0, 0, kLayerHeight);
    
    self.bottomLayer = [CALayer layer];
    self.bottomLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.bottomLayer.bounds = CGRectMake(0, 0, kLayerWidth, kLayerHeight);
    self.bottomLayer.speed = 0;
    [self.bottomLayer addSublayer:self.topLayer];
    [self.view.layer addSublayer:self.bottomLayer];
    
    self.maskTextLayer = [CATextLayer layer];
    self.maskTextLayer.string = @"我会区域变色哦";
    self.maskTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    [self p_commonInitTextLayer:self.maskTextLayer];
    self.maskTextLayer.frame = self.bottomLayer.bounds;
    self.bottomLayer.mask = self.maskTextLayer;
    
    CABasicAnimation *colorAnimation = [CABasicAnimation
                                        animationWithKeyPath:@"foregroundColor"];
    colorAnimation.duration = kAnimationDuration;
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    colorAnimation.fromValue = (id)[UIColor blackColor].CGColor;
    colorAnimation.toValue = (id)[UIColor redColor].CGColor;
    colorAnimation.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation
                                        animationWithKeyPath:@"transform"];
    scaleAnimation.duration = kAnimationDuration;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fromValue = (id)[NSValue valueWithCATransform3D:CATransform3DScale(self.colorTextLayer.transform, 1, 1, 1)];
    scaleAnimation.toValue = (id)[NSValue valueWithCATransform3D:CATransform3DScale(self.colorTextLayer.transform, 1.5, 1.5, 1)];
    scaleAnimation.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionLinear];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = kAnimationDuration;
    animationGroup.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    animationGroup.animations =
    [NSArray arrayWithObjects:colorAnimation, scaleAnimation, nil];
    
    [self.colorTextLayer addAnimation:animationGroup forKey:@"animateColorWithScale"];
    
    scaleAnimation.fromValue = (id)[NSValue valueWithCATransform3D:CATransform3DScale(self.bottomLayer.transform, 1, 1, 1)];
    scaleAnimation.toValue = (id)[NSValue valueWithCATransform3D:CATransform3DScale(self.bottomLayer.transform, 1.5, 1.5, 1)];
    [self.bottomLayer addAnimation:scaleAnimation forKey:@"animateScale"];
}

- (IBAction)onSliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    self.colorTextLayer.timeOffset = slider.value;
    self.bottomLayer.timeOffset = slider.value;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGRect rect = self.topLayer.frame;
    rect.size.width = roundf(self.bottomLayer.frame.size.width * slider.value / kAnimationDuration);
    self.topLayer.frame = rect;
    [CATransaction commit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGPoint center = CGPointMake(roundf(self.view.bounds.size.width / 2), roundf(self.view.bounds.size.height / 4));
    self.colorTextLayer.position = center;
    
    center.y += roundf(self.view.bounds.size.height / 2);
    self.bottomLayer.position = center;
}

- (void)p_commonInitTextLayer:(CATextLayer *)textLayer {
    textLayer.fontSize = kTextLayerFontSize;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.speed = 0.0f;
    textLayer.frame = CGRectMake(0, 0, kLayerWidth, kLayerHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
