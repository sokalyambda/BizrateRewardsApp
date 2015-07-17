//
//  BZRAssetsHelper.h
//  BizrateRewards
//
//  Created by Eugenity on 16.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^AssetsSavingCompletion)(NSURL *assetURL, NSError *error);
typedef void(^AssetsRetrievingCompletion)(UIImage *image, NSDictionary *info);

@interface BZRAssetsHelper : NSObject

+ (void)writeImage:(UIImage *)image withMediaInfo:(NSDictionary *)mediaInfo toPhotoAlbumWithCompletion:(AssetsSavingCompletion)completion;
+ (void)imageFromAssetURL:(NSURL *)url withCompletion:(AssetsRetrievingCompletion)completion;

@end
