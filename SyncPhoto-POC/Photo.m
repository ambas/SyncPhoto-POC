//
//  Photo.m
//  SyncPhoto-POC
//
//  Created by Ambas Chobsanti on 3/28/2558 BE.
//  Copyright (c) 2558 AM. All rights reserved.
//

#import "Photo.h"

@implementation Photo
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"photoName": @"photoName", @"photoURL": @"photoURL"};
}
@end
