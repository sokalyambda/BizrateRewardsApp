//
//  UIImagePickerController+fixOrientation.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 09.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "UIImagePickerController+fixOrientation.h"

@implementation UIImagePickerController (fixOrientation)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
