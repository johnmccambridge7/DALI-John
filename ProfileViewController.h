//
//  ProfileViewController.h
//  DALI
//
//  Created by John MacDonald on 2/11/19.
//  Copyright © 2019 John MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) NSString *sentUsername;
@property (strong, nonatomic) NSString *sentMessage;

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UITextView *bio;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@end

NS_ASSUME_NONNULL_END
