//
//  UIView+Flashable.m
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

// red  0xf15364

#import "UIView+Flashable.h"

@implementation UIView (Flashable)

- (void)flashing
{
    UIColor *fromColor = UIColorFromRGB(0xf15364);
    UIColor *toColor = self.backgroundColor;
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.duration = 0.4f;
    [colorAnimation setRepeatCount:2.f];
    [colorAnimation setAutoreverses:YES];
    colorAnimation.fromValue = (id)fromColor.CGColor;
    colorAnimation.toValue = (id)toColor.CGColor;
    
    CABasicAnimation *flash = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [flash setDuration:0.4f];
    [flash setRepeatCount:2.f];
    [flash setAutoreverses:YES];
    [flash setFromValue:@(self.layer.opacity)];
    [flash setToValue:@0];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[colorAnimation, flash];
    animationGroup.duration = 1.f;
    
    CALayer *roundedLayer = [CALayer layer];
    roundedLayer.frame = self.bounds;
    roundedLayer.cornerRadius = CGRectGetWidth(self.frame)/2.f;
    
    [self.layer addSublayer:roundedLayer];
    
    [roundedLayer addAnimation:animationGroup forKey:@"flashing"];
}

@end
