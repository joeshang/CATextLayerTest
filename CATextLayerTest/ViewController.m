//
//  ViewController.m
//  CATextLayerTest
//
//  Created by Joe Shang on 7/14/15.
//  Copyright (c) 2015 Shang Chuanren. All rights reserved.
//

#import "ViewController.h"

static CGFloat const kTextLayerFontSize = 29.0f;
static CGFloat const kTextLayerSelectedFontSize = 35.0f;
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

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initLayers];
    [self p_addAnimationForLayers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGPoint center = CGPointMake(roundf(self.view.bounds.size.width / 2), roundf(self.view.bounds.size.height / 4));
    self.colorTextLayer.position = center;
    
    center.y += roundf(self.view.bounds.size.height / 2);
    self.bottomLayer.position = center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target-Action

- (IBAction)onSliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    self.colorTextLayer.timeOffset = slider.value;
    self.maskTextLayer.timeOffset = slider.value;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGRect rect = self.topLayer.frame;
    rect.size.width = roundf(self.bottomLayer.frame.size.width * slider.value / kAnimationDuration);
    self.topLayer.frame = rect;
    [CATransaction commit];
}

#pragma mark - Private

- (void)p_initLayers {
    self.colorTextLayer = [CATextLayer layer];
    self.colorTextLayer.string = @"我会整体变色哦";
    self.colorTextLayer.foregroundColor = [UIColor blackColor].CGColor;
    [self p_commonInitTextLayer:self.colorTextLayer];
    [self.view.layer addSublayer:self.colorTextLayer];
    
    self.topLayer = [CALayer layer];
    self.topLayer.backgroundColor = [UIColor blueColor].CGColor;
    self.topLayer.frame = CGRectMake(0, 0, 0, kLayerHeight);
    
    self.bottomLayer = [CALayer layer];
    self.bottomLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.bottomLayer.bounds = CGRectMake(0, 0, kLayerWidth, kLayerHeight);
    [self.bottomLayer addSublayer:self.topLayer];
    [self.view.layer addSublayer:self.bottomLayer];
    
    self.maskTextLayer = [CATextLayer layer];
    self.maskTextLayer.string = @"我会区域变色哦";
    self.maskTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    [self p_commonInitTextLayer:self.maskTextLayer];
    self.maskTextLayer.frame = self.bottomLayer.bounds;
    self.bottomLayer.mask = self.maskTextLayer;
}

- (void)p_addAnimationForLayers {
    
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
                                        animationWithKeyPath:@"fontSize"];
    scaleAnimation.duration = kAnimationDuration;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fromValue = @(kTextLayerFontSize);
    scaleAnimation.toValue = @(kTextLayerSelectedFontSize);
    scaleAnimation.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionLinear];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = kAnimationDuration;
    animationGroup.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    animationGroup.animations = @[colorAnimation, scaleAnimation];
    
    self.colorTextLayer.speed = 0.0f;
    [self.colorTextLayer addAnimation:animationGroup forKey:@"animateColorAndFontSize"];
    
    self.maskTextLayer.speed = 0.0f;
    [self.maskTextLayer addAnimation:scaleAnimation forKey:@"animateFontSize"];
}

- (void)p_commonInitTextLayer:(CATextLayer *)textLayer {
    textLayer.fontSize = kTextLayerFontSize;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.frame = CGRectMake(0, 0, kLayerWidth, kLayerHeight);
}

@end
