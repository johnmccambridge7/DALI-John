//
//  ViewController.m
//  DALI
//
//  Created by John MacDonald on 2/10/19.
//  Copyright © 2019 John MacDonald. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    // Creates a marker in the center of the map.
    /*GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView;*/
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    CGRect f = CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height);
    GMSMapView *mv = [GMSMapView mapWithFrame:f camera:camera];
    mv.myLocationEnabled = YES;
    //
    [self.mapView addSubview:mv];
}


@end
