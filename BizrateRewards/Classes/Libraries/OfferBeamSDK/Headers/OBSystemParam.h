//
//  OBSystemParam.h
//  SymphonyEYC
//
//  Created by Praveen Kumar on 4/9/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OBSystemParam : NSManagedObject

@property (nonatomic, retain) NSNumber * param_id;
@property (nonatomic, retain) NSString * param_name;
@property (nonatomic, retain) NSNumber * param_value;

@end
