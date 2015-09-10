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

@property (nonatomic, strong) CALayer *bottomLayer;
@property (nonatomic, strong) CALayer *topLayer;
@property (nonatomic, strong) CATextLayer *maskTextLayer;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化图层
    [self p_initLayers];
    
    //添加动画效果
    [self p_addAnimationForLayers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //网易新闻
    CGPoint center = CGPointMake(roundf(self.view.bounds.size.width / 2), roundf(self.view.bounds.size.height / 4));
    self.colorTextLayer.position = center;
    
    //歌词
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
    
    //网易新闻
    self.colorTextLayer.timeOffset = slider.value;
    
    //歌词
    [CATransaction begin];
    CGRect rect = self.topLayer.frame;
    rect.size.width = roundf(self.bottomLayer.frame.size.width * slider.value / kAnimationDuration);
    self.topLayer.frame = rect;
    [CATransaction commit];
}

#pragma mark - Private

- (void)p_initLayers {
    //网易新闻
    self.colorTextLayer = [CATextLayer layer];
    self.colorTextLayer.string = @"我会整体变色哦";
    self.colorTextLayer.foregroundColor = [UIColor blackColor].CGColor;
    [self p_commonInitTextLayer:self.colorTextLayer];
    [self.view.layer addSublayer:self.colorTextLayer];
    
    //歌词
    self.bottomLayer = [CALayer layer];
    self.bottomLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.bottomLayer.bounds = CGRectMake(0, 0, kLayerWidth, kLayerHeight);
    [self.view.layer addSublayer:self.bottomLayer];
    
    self.topLayer = [CALayer layer];
    self.topLayer.backgroundColor = [UIColor blueColor].CGColor;
    self.topLayer.frame = CGRectMake(0, 0, 0, kLayerHeight);
    [self.bottomLayer addSublayer:self.topLayer];
    
    self.maskTextLayer = [CATextLayer layer];
    self.maskTextLayer.string = @"我会区域变色哦";
    self.maskTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    [self p_commonInitTextLayer:self.maskTextLayer];
    self.maskTextLayer.frame = self.bottomLayer.bounds;
    
    //设置图层蒙板
    self.bottomLayer.mask = self.maskTextLayer;
}

- (void)p_addAnimationForLayers {
    //网易新闻
    CABasicAnimation *colorAnimation = [CABasicAnimation
                                        animationWithKeyPath:@"foregroundColor"];
    colorAnimation.fromValue = (id)[UIColor blackColor].CGColor;
    colorAnimation.toValue = (id)[UIColor redColor].CGColor;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation
                                        animationWithKeyPath:@"fontSize"];
    scaleAnimation.fromValue = @(kTextLayerFontSize);
    scaleAnimation.toValue = @(kTextLayerSelectedFontSize);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = kAnimationDuration;
    animationGroup.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    animationGroup.animations = @[colorAnimation, scaleAnimation];
    
    self.colorTextLayer.speed = 0.0f;
    [self.colorTextLayer addAnimation:animationGroup forKey:@"animateColorAndFontSize"];
    
    //歌词 通过改变frame来完成动画效果
}

- (void)p_commonInitTextLayer:(CATextLayer *)textLayer {
    textLayer.fontSize = kTextLayerFontSize;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.frame = CGRectMake(0, 0, kLayerWidth, kLayerHeight);
}

@end
