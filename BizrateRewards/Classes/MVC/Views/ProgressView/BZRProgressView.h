//
//  ProgressView.h
//  AnimationView
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRProgressView : UIProgressView

- (void)recalculateProgressWithCurrentPoints:(NSInteger)currentPoints requiredPoints:(NSInteger)requiredPoints withCompletion:(void(^)(BOOL maxPointsEarned))completion;

@end
