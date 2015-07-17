//
//  BZRAssetsHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 16.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRAssetsHelper.h"

#import <AssetsLibrary/AssetsLibrary.h>

@import Photos;

@implementation BZRAssetsHelper

+ (void)writeImage:(UIImage *)image withMediaInfo:(NSDictionary *)mediaInfo toPhotoAlbumWithCompletion:(AssetsSavingCompletion)completion
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:image.CGImage
                                 metadata:mediaInfo[UIImagePickerControllerMediaMetadata]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              completion(assetURL, error);
                          }];
}

+ (void)imageFromAssetURL:(NSURL *)url withCompletion:(AssetsRetrievingCompletion)completion
{
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.resizeMode = PHImageRequestOptionsResizeModeExact;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    if (url) {
        PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
        [[PHImageManager defaultManager] requestImageDataForAsset:result.firstObject options:option resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            UIImage *image = [UIImage imageWithData:imageData];
            completion(image, info);
        }];
    }
}

@end
