//
//  Photo.h
//  SyncPhoto-POC
//
//  Created by Ambas Chobsanti on 3/28/2558 BE.
//  Copyright (c) 2558 AM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface Photo : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *photoName;
@property (nonatomic, strong) NSString *photoURL;

@end
