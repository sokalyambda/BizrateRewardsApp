//
//  BZRLocationEventService.h
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@interface BZRLocationEventService : NSObject

+ (BZRLocationEvent *)locationEventFromServerResponse:(NSDictionary *)response;
+ (BZRLocationEvent *)locationEventFromOfferBeamResponse:(NSDictionary *)locationData;

+ (void)setLocationEvent:(BZRLocationEvent *)locationEvent
        toDefaultsForKey:(NSString *)key;
+ (BZRLocationEvent *)locationEventFromDefaultsForKey:(NSString *)key;

+ (void)encodeLocationEvent:(BZRLocationEvent *)locationEvent
                withEncoder:(NSCoder *)encoder;
+ (BZRLocationEvent *)decodeLocationEvent:(BZRLocationEvent *)locationEvent
                              withDecoder:(NSCoder *)decoder;

@end
