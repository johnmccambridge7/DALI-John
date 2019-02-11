//
//  MembersViewController.m
//  DALI
//
//  Created by John MacDonald on 2/10/19.
//  Copyright © 2019 John MacDonald. All rights reserved.
//

#import "MembersViewController.h"
#import "SimpleTableCell.h"

@interface MembersViewController ()
@end
@implementation MembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.names = [[NSMutableArray alloc] init];
    self.messages = [[NSMutableArray alloc] init];
    self.urls = [[NSMutableArray alloc] init];
    
    self.tableLimit = (NSUInteger *) [self.cacheData count];
    
    for(int i = 0; i < self.cacheData.count; i++) {
        NSDictionary *person = [self.cacheData objectAtIndex:i];
        NSString *name = [person objectForKey:@"name"];
        NSString *message = [person objectForKey:@"message"];
        NSString *icon = [person objectForKey:@"iconUrl"];
        [self.names addObject:name];
        [self.messages addObject:message];
        [self.urls addObject:icon];
    }
    
    NSLog(@"%@", self.cacheData);
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)sort:(id)sender {
    self.names = [[NSMutableArray alloc] init];
    self.messages = [[NSMutableArray alloc] init];
    self.urls = [[NSMutableArray alloc] init];
    
    NSDictionary *newTableData = @{};
    
    if(![[self.segment titleForSegmentAtIndex:self.segment.selectedSegmentIndex] isEqualToString:@"All"]) {
        
        if([[self.segment titleForSegmentAtIndex:self.segment.selectedSegmentIndex] isEqualToString:@"Project"]) {
            newTableData = [self groupDictionary:self.cacheData groupBy:@"project"];
        } else if([[self.segment titleForSegmentAtIndex:self.segment.selectedSegmentIndex] isEqualToString:@"Term"]) {
            newTableData = [self groupDictionary:self.cacheData groupBy:@"terms_on"];
        }
        
        for(NSString *key in newTableData) {
            for(NSArray *person in [newTableData objectForKey:key]) {
                
                NSArray *pn = [person objectAtIndex:0];
                NSString *name = [pn objectAtIndex:0];
                NSString *icon = [pn objectAtIndex:2];
                
                [self.names addObject:name];
                [self.messages addObject:key];
                [self.urls addObject:icon];
                
            }
        }
        
    } else {
        for(int i = 0; i < self.cacheData.count; i++) {
            NSDictionary *person = [self.cacheData objectAtIndex:i];
            NSString *name = [person objectForKey:@"name"];
            NSString *message = [person objectForKey:@"message"];
            NSString *icon = [person objectForKey:@"iconUrl"];
            [self.names addObject:name];
            [self.messages addObject:message];
            [self.urls addObject:icon];
        }
    }
    
    self.tableLimit = (NSInteger *) [self.names count];
    
    [self.tableView reloadData];
}

- (NSDictionary *) groupDictionary:(NSArray *)cache groupBy:(NSString *)key {
    NSMutableDictionary *groupedDictionary = [[NSMutableDictionary alloc] init];
    
    // sorts the main cache file into project groups
    for(int i = 0; i < cache.count; i++) {
        NSDictionary *person = [cache objectAtIndex:i];
        NSArray *grouping_keys = [person objectForKey:key];
        
        NSString *name = [person objectForKey:@"name"];
        NSString *message = [person objectForKey:@"message"];
        NSString *icon = [person objectForKey:@"iconUrl"];
        
        NSArray *personal_information = [NSArray arrayWithObject:@[name, message, icon]];

        for(NSString *k in grouping_keys) {
            
            NSString *dictionaryKey = k;
            
            if([dictionaryKey isEqualToString:@""]) {
                dictionaryKey = @"Currently not working on a project.";
            }
            
            if([groupedDictionary objectForKey:dictionaryKey] == nil) {
                NSMutableArray *empty = [[NSMutableArray alloc] init];
                [empty addObject:personal_information];
                [groupedDictionary setObject:empty forKey:dictionaryKey];
            } else {
                NSMutableArray *group_list = [groupedDictionary objectForKey:dictionaryKey];
                [group_list addObject:personal_information];
                [groupedDictionary setObject:group_list forKey:dictionaryKey];
            }
        }
        
    }

    return groupedDictionary;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableLimit;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLabel.text = [self.names objectAtIndex:indexPath.row];
    cell.thumbnailImageView.image = [UIImage imageNamed:@"placeholder.png"];
    cell.message.text = [self.messages objectAtIndex:indexPath.row];
    
    NSString *image_location = [self.urls objectAtIndex:indexPath.row];
    NSString *unencoded_url = [NSString stringWithFormat:@"https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/%@", image_location];
    NSString *encoded_url = [unencoded_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSURL *url = [NSURL URLWithString:encoded_url];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SimpleTableCell *updatedCell = (SimpleTableCell *)[tableView cellForRowAtIndexPath:indexPath];
                    if (updatedCell)
                        updatedCell.thumbnailImageView.image = image;
                });
            }
        }
    }];
    
    [task resume];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

@end
