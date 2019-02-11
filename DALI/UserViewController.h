//
//  UserViewController.h
//  DALI
//
//  Created by John MacDonald on 2/11/19.
//  Copyright © 2019 John MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserViewController : UIViewController
@property (strong, nonatomic) NSString *sentUsername;
@property (strong, nonatomic) NSString *sentMessage;
@property (strong, nonatomic) NSString *sentBio;
@property (strong, nonatomic) NSString *sentLabel;
@property (strong, nonatomic) NSURL *sentIcon;
@property (strong, nonatomic) NSArray *sentPoint;


@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UITextView *bio;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@end

NS_ASSUME_NONNULL_END
