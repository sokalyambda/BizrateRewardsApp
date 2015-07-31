//
//  BZRBaseOverlapView.h
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@class BZRBaseOverlapView;

typedef void(^OverlapCompletion)(BZRBaseOverlapView *overlapView, BOOL isCanceled);

@interface BZRBaseOverlapView : UIView

+ (void)showWithCompletion:(OverlapCompletion)completion;

@end
