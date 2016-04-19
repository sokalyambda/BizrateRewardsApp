//
//  BZRSharingManager.h
//  Bizrate Rewards
//
//  Created by Kate Chupova on 4/11/16.
//  Copyright © 2016 Connexity. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ShareBody(inviteCode) [NSString stringWithFormat:@"Use my invite code, %@, when you sign up for Bizrate Rewards and get up to 350 extra points!", inviteCode]

@import MessageUI;

typedef enum : NSUInteger {
    BZRSharingFacebook,
    BZRSharingTwitter,
} BZRSharingType;

@protocol BZRSharingManagerDelegate <NSObject>

@optional
- (void)sharingWasCanceledForType:(BZRSharingType)sharingType;
- (void)sharingDoneForType:(BZRSharingType)sharingType;

@end

@interface BZRSharingManager : NSObject

@property (weak, nonatomic) id<BZRSharingManagerDelegate> delegate;

+ (BZRSharingManager *)sharedManager;

- (void)shareWithTwitterFromController:(UIViewController*)fromController inviteCode:(NSString*)inviteCode;
- (void)shareWithFacebookFromController:(UIViewController*)fromController inviteCode:(NSString*)inviteCode;
- (void)shareWithEmailFromController:(UIViewController*)fromController inviteCode:(NSString*)inviteCode;
- (void)shareWithMessageFromController:(UIViewController*)fromController inviteCode:(NSString*)inviteCode;

@end
