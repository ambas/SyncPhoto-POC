//
//  ViewController.m
//  SyncPhoto-POC
//
//  Created by Ambas Chobsanti on 3/28/2558 BE.
//  Copyright (c) 2558 AM. All rights reserved.
//

#import "ViewController.h"
#import "AMMultiPeer.h"
#import "Photo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Mantle/Mantle.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[AMMultiPeer sharedManager] advertiseSelf:YES messageHandler:^(NSDictionary *result) {
        Photo *photo = [MTLJSONAdapter modelOfClass:Photo.class fromJSONDictionary:result error:nil];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:photo.photoURL]];
        self.inageName.text = photo.photoName;
    }];
    [AMMultiPeer sharedManager].didAcceptConnectionHandler = ^{
        NSLog((@"fuck u"));
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)browseDevice:(id)sender {
    [[AMMultiPeer sharedManager] showBrowserWithTarget:self];
}
- (IBAction)pic1:(id)sender {
    Photo *photo = [[Photo alloc] init];
    photo.photoName = @"Ambas";
    photo.photoURL = @"https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-xfa1/v/t1.0-9/1009752_676391269042006_606169399_n.jpg?oh=b331779b62687657ff48c47846d65bb3&oe=55A5AC9F&__gda__=1436896790_6884998c3797f6285bade6bb79da9516";
    NSDictionary *photoDict =  [MTLJSONAdapter JSONDictionaryFromModel:photo];
    [[AMMultiPeer sharedManager] sendDictionaryToAllPeer:photoDict];
}
- (IBAction)pic2:(id)sender {
    Photo *photo = [[Photo alloc] init];
    photo.photoName = @"Ratom";
    photo.photoURL = @"https://fbcdn-sphotos-e-a.akamaihd.net/hphotos-ak-prn2/v/t1.0-9/530319_440148049416227_169958241_n.jpg?oh=f95c4331f303eeaf0211787e681aa4fe&oe=55BB2642&__gda__=1433940492_ccefdcff8878e3660ddbdf477c8df6d1";
    NSDictionary *photoDict =  [MTLJSONAdapter JSONDictionaryFromModel:photo];
    [[AMMultiPeer sharedManager] sendDictionaryToAllPeer:photoDict];
}

@end
