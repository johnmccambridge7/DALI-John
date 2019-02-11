//
//  MembersViewController.h
//  DALI
//
//  Created by John MacDonald on 2/10/19.
//  Copyright © 2019 John MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MembersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) NSArray *tableData;
@property (nonatomic, strong) NSArray *cacheData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *names;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *urls;

@property NSInteger *tableLimit;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@end

NS_ASSUME_NONNULL_END
