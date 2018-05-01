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
    
    [self setupLayers];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGPoint center = CGPointMake(roundf(self.view.bounds.size.width / 2), roundf(self.view.bounds.size.height / 4));
    self.colorTextLayer.position = center;
    
    center.y += roundf(self.view.bounds.size.height / 2);
    self.bottomLayer.position = center;
}

#pragma mark - Setup Method

- (void)setupLayers {
    [self.view.layer addSublayer:self.colorTextLayer];

    self.bottomLayer.mask = self.maskTextLayer;
    [self.bottomLayer addSublayer:self.topLayer];
    [self.view.layer addSublayer:self.bottomLayer];
    
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

#pragma mark - Target Action

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

#pragma mark - Getters

- (CATextLayer *)colorTextLayer {
    if (!_colorTextLayer) {
        _colorTextLayer = [CATextLayer layer];
        _colorTextLayer.string = @"我会整体变色哦";
        _colorTextLayer.foregroundColor = [UIColor blackColor].CGColor;
        _colorTextLayer.fontSize = kTextLayerFontSize;
        _colorTextLayer.contentsScale = [[UIScreen mainScreen] scale];
        _colorTextLayer.alignmentMode = kCAAlignmentCenter;
        _colorTextLayer.frame = CGRectMake(0, 0, kLayerWidth, kLayerHeight);
    }
    return _colorTextLayer;
}

- (CATextLayer *)maskTextLayer {
    if (!_maskTextLayer) {
        _maskTextLayer = [CATextLayer layer];
        _maskTextLayer.string = @"我会区域变色哦";
        _maskTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
        _maskTextLayer.fontSize = kTextLayerFontSize;
        _maskTextLayer.contentsScale = [[UIScreen mainScreen] scale];
        _maskTextLayer.alignmentMode = kCAAlignmentCenter;
        _maskTextLayer.frame = CGRectMake(0, 0, kLayerWidth, kLayerHeight);
    }
    return _maskTextLayer;
}

- (CALayer *)topLayer {
    if (!_topLayer) {
        _topLayer = [CALayer layer];
        _topLayer.backgroundColor = [UIColor blueColor].CGColor;
        _topLayer.frame = CGRectMake(0, 0, 0, kLayerHeight);
    }
    return _topLayer;
}

- (CALayer *)bottomLayer {
    if (!_bottomLayer) {
        _bottomLayer = [CALayer layer];
        _bottomLayer.backgroundColor = [UIColor blackColor].CGColor;
        _bottomLayer.bounds = CGRectMake(0, 0, kLayerWidth, kLayerHeight);
    }
    return _bottomLayer;
}
@end
