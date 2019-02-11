//
//  SimpleTableViewCell.m
//  DALI
//
//  Created by John MacDonald on 2/10/19.
//  Copyright © 2019 John MacDonald. All rights reserved.
//

#import "SimpleTableCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SimpleTableCell

@synthesize nameLabel = _nameLabel;
@synthesize message = _message;
@synthesize thumbnailImageView = _thumbnailImageView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.thumbnailImageView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.thumbnailImageView.layer setShadowOpacity:0.8];
    [self.thumbnailImageView.layer setShadowRadius:3.0];
    [self.thumbnailImageView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
