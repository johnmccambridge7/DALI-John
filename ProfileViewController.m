//
//  ProfileViewController.m
//  DALI
//
//  Created by John MacDonald on 2/11/19.
//  Copyright © 2019 John MacDonald. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.text = self.sentUsername;
    self.message.text = self.sentMessage;
}


@end
