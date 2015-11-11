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

/**
 *  Write image to local device storage
 *
 *  @param image      Image that will be written
 *  @param mediaInfo  Image media info dictionary
 *  @param completion Completion Block
 */
+ (void)writeImage:(UIImage *)image withMediaInfo:(NSDictionary *)mediaInfo toPhotoAlbumWithCompletion:(AssetsSavingCompletion)completion
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:image.CGImage
                                 metadata:mediaInfo[UIImagePickerControllerMediaMetadata]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              completion(assetURL, error);
                          }];
}

/**
 *  Get image from asset's URL
 *
 *  @param url        URL for image asset
 *  @param completion Completion Block
 */
+ (void)imageFromAssetURL:(NSURL *)url withCompletion:(AssetsRetrievingCompletion)completion
{
    if (url) {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        
        imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        imageRequestOptions.networkAccessAllowed = YES;
        imageRequestOptions.synchronous = YES;
        imageRequestOptions.version = PHImageRequestOptionsVersionOriginal;
        
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.includeAllBurstAssets = YES;
        fetchOptions.includeHiddenAssets = YES;
        
        PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:fetchOptions];
        [[PHImageManager defaultManager] requestImageDataForAsset:result.firstObject options:imageRequestOptions resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            
            UIImage *image = [UIImage imageWithData:imageData];
            completion(image, info);
        }];
    }
}

@end
