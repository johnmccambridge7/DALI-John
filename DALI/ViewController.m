//
//  ViewController.m
//  DALI
//
//  Created by John MacDonald on 2/10/19.
//  Copyright © 2019 John MacDonald. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchJSON];
}

- (void) fetchJSON {
    
    // Asyncroniously gather the JSON data
    [self startLoading];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@", @"https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/members.json"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.timeoutIntervalForRequest = 120.0;
    defaultConfigObject.timeoutIntervalForResource = 120.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Something unexpected happened!"
                                        message:@"We're not sure what just happened. Please try again."
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *retryButton = [UIAlertAction
                                          actionWithTitle:@"Retry"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action) {
                                              
                                              [self fetchJSON];
                                              
                                          }];
     
            
            [alert addAction:retryButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            
            NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            self.cache = array;
            
            self.count.text = @"-";
            
            NSMutableArray *points = [[NSMutableArray alloc] init];
            NSMutableArray *info = [[NSMutableArray alloc] init];
            NSMutableArray *messages = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < self.cache.count; i++) {
                NSDictionary *person = [array objectAtIndex:i];
                NSArray *latlong = [person objectForKey:@"lat_long"];
                NSString *name = [person objectForKey:@"name"];
                NSString *message = [person objectForKey:@"message"];
                [points addObject:latlong];
                [info addObject:name];
                [messages addObject:message];
            }
            
            [self initMap:points info:info messages:messages];
            
            float animationPeriod = 2;
            
            int limit = (int) self.cache.count;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                for (int i = 1; i < limit; i ++) {
                    usleep(animationPeriod/limit * 1000000); // sleep in microseconds
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.count.text = [NSString stringWithFormat:@"%d", i];
                    });
                }
            });

        }
        
        [self endLoading];
    }];
    
    
    
    [task resume];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    UIView *v = self.mapView;
    
    [v.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [v.layer setShadowOpacity:0.8];
    [v.layer setShadowRadius:3.0];
    [v.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [self.members.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.members.layer setShadowOpacity:0.8];
    [self.members.layer setShadowRadius:3.0];
    [self.members.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

- (void) initMap:(NSMutableArray *) points info:(NSMutableArray *) info messages:(NSMutableArray *) messages {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.50                       longitude:-98.35
        zoom:2];
    CGRect f = CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height);
    GMSMapView *mv = [GMSMapView mapWithFrame:f camera:camera];
    mv.myLocationEnabled = YES;
    //
    [self.mapView addSubview:mv];
    
    // Creates a marker in the center of the map.
    for(int i=1; i < points.count; i++) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        NSLog(@"%f", [[[points objectAtIndex:i] objectAtIndex:0] doubleValue]);
        marker.position = CLLocationCoordinate2DMake([[[points objectAtIndex:i] objectAtIndex:0] doubleValue], [[[points objectAtIndex:i] objectAtIndex:1] doubleValue]);
        marker.title = [info objectAtIndex:i];
        marker.snippet = [messages objectAtIndex:i];
        marker.map = mv;
    }

}

- (void) startLoading {
    
    self.spinner.alpha = 1.0f;
    self.view.userInteractionEnabled = NO;
    self.view.alpha = 0.3f;
}

- (void) endLoading {
    self.spinner.alpha = 0.0f;
    self.view.userInteractionEnabled = YES;
    self.view.alpha = 1.0f;
}


@end
