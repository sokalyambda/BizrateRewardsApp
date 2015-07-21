//
//  OB_NetworkManager.h
//  SymphonyEYC
//
//  Created by Praveen Kumar on 4/1/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OB_NetworkManager : NSObject


-(void) OBPost:(NSString *) urlString Parameters:(NSDictionary *) params onCompletion:(void (^)(NSDictionary *json, NSError *error,BOOL success))onCompletion;
-(void) OBGet:(NSString *) urlString onCompletion:(void (^)(NSDictionary *json, NSError *error,BOOL success))onCompletion;

-(void) OBPostOnMain:(NSString *) urlString Parameters:(NSDictionary *) params onCompletion:(void (^)(NSDictionary *json, NSError *error,BOOL success))onCompletion;


@end
