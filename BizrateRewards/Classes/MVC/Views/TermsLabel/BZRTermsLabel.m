//
//  BZRTermsLabel.m
//  Bizrate Rewards
//
//  Created by Eugenity on 21.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRTermsLabel.h"

#import "UIFont+Styles.h"

static NSString *const kTermsLink = @"http://www.bizraterewards.com/mobile-terms.html";

@implementation BZRTermsLabel

#pragma mark - Accessors

- (void)setText:(id)text
{
    self.font = [UIFont privacyAndTermsFont];
    
    [super setText:text];
    
    NSDictionary *linkAttributes = @{
                                 NSFontAttributeName: [UIFont privacyAndTermsFont],
                                 NSUnderlineStyleAttributeName: @0,
                                 (id)kCTForegroundColorAttributeName: UIColorFromRGB(0x1593CD)
                                 };
    NSDictionary *activeLinkAttributes = @{
                                     NSFontAttributeName: [UIFont privacyAndTermsFont],
                                     NSUnderlineStyleAttributeName: @0,
                                     (id)kCTForegroundColorAttributeName: UIColorFromRGB(0x9097a3)
                                     };
    self.linkAttributes = linkAttributes;
    self.activeLinkAttributes = activeLinkAttributes;
    
    NSRange privacyPolicyRange = [self.text rangeOfString:@"Privacy Policy"];
    NSRange programTermsRange = [self.text rangeOfString:@"Program Terms"];
    
    if (privacyPolicyRange.location != NSNotFound) {
        [self addLinkToURL:[NSURL URLWithString:kTermsLink] withRange:privacyPolicyRange];
    }
    if (programTermsRange.location != NSNotFound) {
        [self addLinkToURL:[NSURL URLWithString:kTermsLink] withRange:programTermsRange];
    }
}

@end
