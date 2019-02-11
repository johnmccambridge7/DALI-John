//
//  UserViewController.m
//  DALI
//
//  Created by John MacDonald on 2/11/19.
//  Copyright © 2019 John MacDonald. All rights reserved.
//

#import "UserViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.text = self.sentUsername;
    self.message.text = self.sentMessage;
    self.bio.text = self.sentBio;
    self.mapLabel.text = self.sentLabel;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:self.sentIcon completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.img.image = image;
                });
            }
        }
    }];
    
    [task resume];

    [self.img.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.img.layer setShadowOpacity:0.8];
    [self.img.layer setShadowRadius:3.0];
    [self.img.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self initMap:self.sentPoint];
}

- (void) initMap:(NSArray *) point{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[point objectAtIndex:0] doubleValue]                       longitude:[[point objectAtIndex:1] doubleValue] zoom:3];
    CGRect f = CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height);
    GMSMapView *mv = [GMSMapView mapWithFrame:f camera:camera];
    mv.myLocationEnabled = YES;
    
    [self.mapView addSubview:mv];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([[point objectAtIndex:0] doubleValue], [[point objectAtIndex:1] doubleValue]);
    marker.title = self.username.text;
    marker.snippet = self.message.text;
    marker.map = mv;
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
