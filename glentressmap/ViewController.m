//
//  ViewController.m
//  glentressmap
//
//  Created by murray on 30/03/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "Mapbox.h"

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoibXVycmF5aGtpbmciLCJhIjoiZVVfeGhqNCJ9.WJaoPywqu21-rgRkQJqsKQ"];
    /*
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"murrayhking.b9t2umru"];
    
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds
                                            andTilesource:tileSource];
    // set zoom
    mapView.zoom = 1;
    
    // set coordinates
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(55.9360,-3.1804);
    
    // center the map to the coordinates
    mapView.centerCoordinate = center;
    
    [self.view addSubview:mapView];*/
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"hd_inners" ofType:@"mbtiles"];
    
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    
    mapView.zoom = 2;
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    mapView.adjustTilesForRetinaDisplay = YES; // these tiles aren't designed specifically for retina, so make them legible
    
    [self.view addSubview:mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
