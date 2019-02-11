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

@implementation NSString (NSString_Extended)

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

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
    // 0 == Project
    // 1 == Term
    NSMutableDictionary *projects = [[NSMutableDictionary alloc] init];
    
    for(int i = 0; i < self.cacheData.count; i++) {
        NSDictionary *person = [self.cacheData objectAtIndex:i];
        NSArray *p = [person objectForKey:@"project"];
        
        NSString *name = [person objectForKey:@"name"];
        NSString *message = [person objectForKey:@"message"];
        NSString *icon = [person objectForKey:@"iconUrl"];
        
        for(NSString *project in p) {
            NSArray *ma = [NSArray arrayWithObject:@[name, message, icon]];
            NSString *key = project;
            
            if([key isEqualToString:@""]) {
                key = @"Currently not working on a project.";
            }
            
            if([projects objectForKey:key] == nil) {
                NSMutableArray *hold = [[NSMutableArray alloc] init];
                
                [hold addObject:ma];
                
                [projects setObject:hold forKey:key];
            } else {
                NSMutableArray *hold = [projects objectForKey:key];
                
                [hold addObject:ma];
                
                [projects setObject:hold forKey:key];
            }
        }
        
    }
    
    self.names = [[NSMutableArray alloc] init];
    self.messages = [[NSMutableArray alloc] init];
    self.urls = [[NSMutableArray alloc] init];
    
    for(NSString *key in projects) {
        for(NSArray *person in [projects objectForKey:key]) {
            NSArray *pn = [person objectAtIndex:0];
            NSString *name = [pn objectAtIndex:0];
            NSString *icon = [pn objectAtIndex:2];
            [self.names addObject:name];
            [self.messages addObject:key];
            [self.urls addObject:icon];
        }
    }
    
    self.tableLimit = [self.names count];
    
    [self.tableView reloadData];
    
    NSLog(@"item changed");
    NSLog(@"%@", self.names);
    NSLog(@"%@", self.messages);
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
    cell.thumbnailImageView.image = [UIImage imageNamed:@"projects.png"];
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
