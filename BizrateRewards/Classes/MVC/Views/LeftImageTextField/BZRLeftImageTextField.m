//
//  CSTAuthorizationTextField.m
//  CarusselSalesTool
//
//  Created by Eugenity on 02.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRLeftImageTextField.h"

static CGFloat kLeftViewWidth = 36.f;

@interface BZRLeftImageTextField ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation BZRLeftImageTextField

#pragma mark - Accessors

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self addLeftImage];
}

#pragma mark - Actions

- (void)addLeftImage
{
    [self.imageView removeFromSuperview];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageName]];
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    UIView *emailLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLeftViewWidth, CGRectGetHeight(self.frame))];
    [emailLeftView addSubview:self.imageView];
    self.imageView.center = emailLeftView.center;
    self.leftView = emailLeftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
