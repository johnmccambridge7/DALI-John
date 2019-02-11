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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/%@", [self.urls objectAtIndex:indexPath.row]]];
    
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
