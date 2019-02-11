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
    //NSMutableArray *urls = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.cacheData.count; i++) {
        NSDictionary *person = [self.cacheData objectAtIndex:i];
        NSString *name = [person objectForKey:@"name"];
        NSString *message = [person objectForKey:@"message"];
        [self.names addObject:name];
        [self.messages addObject:message];
    }
    
    NSLog(@"%@", self.cacheData);
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cacheData count];
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
    cell.thumbnailImageView.image = [UIImage imageNamed:@"projects.png"];
    cell.message.text = [self.messages objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

@end
