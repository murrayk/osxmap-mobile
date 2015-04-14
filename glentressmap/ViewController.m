//
//  ViewController.m
//  glentressmap
//
//  Created by murray on 30/03/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "Mapbox.h"

#import "ViewController.h"
#import "SimpleKML.h"
#import "SimpleKMLContainer.h"
#import "SimpleKMLDocument.h"
#import "SimpleKMLFeature.h"
#import "SimpleKMLPlacemark.h"
#import "SimpleKMLPoint.h"
#import "SimpleKMLPolygon.h"
#import "SimpleKMLLinearRing.h"
#import "SimpleKMLLineString.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray * routePoints;


@end

@implementation ViewController

-(NSMutableArray *) routePoints{
    if(_routePoints == nil){
        _routePoints = [[NSMutableArray alloc] init];
    }
    return _routePoints;
}

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
    
    NSError *error;
    
    mapView.delegate = self;

    // set zoom
    mapView.zoom = 11;
    
      //
    SimpleKML *kml = [SimpleKML KMLWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"innersxc" ofType:@"kml"] error:&error];
    if (error) { NSLog(@"%@", error); }
    
    // look for a document feature in it per the KML spec
    //
    if (kml.feature && [kml.feature isKindOfClass:[SimpleKMLDocument class]])
    {
        // see if the document has features of its own
        //
        for (SimpleKMLFeature *feature in ((SimpleKMLContainer *)kml.feature).features)
        {
            // see if we have any placemark features with a point
            //
            if ([feature isKindOfClass:[SimpleKMLPlacemark class]] && ((SimpleKMLPlacemark *)feature).point)
            {
                SimpleKMLPoint *point = ((SimpleKMLPlacemark *)feature).point;
                
                // create a normal point annotation for it
                //
                RMPointAnnotation *annotation = [[RMPointAnnotation alloc] init];
                
                annotation.coordinate = point.coordinate;
                annotation.title      = feature.name;
                
                [mapView addAnnotation:annotation];
            }
            
            // otherwise, see if we have any placemark features with a polygon
            //
            else if ([feature isKindOfClass:[SimpleKMLPlacemark class]] && ((SimpleKMLPlacemark *)feature).geometry)
            {
                SimpleKMLGeometry *geometry = (SimpleKMLGeometry *)((SimpleKMLPlacemark *)feature).geometry;
                    

                    [self.routePoints addObject:geometry];
                    
            

            }
        }
    }
    
    
    NSLog(@" Test array %@ ", self.routePoints);
    
    
    
    //get the first point.
    SimpleKMLLineString *lineString = (SimpleKMLLineString *)self.routePoints[0];
    CLLocation *firstPoint = (CLLocation *)lineString.coordinates[0];
    
    
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                        coordinate:firstPoint.coordinate andTitle:@"Home"];

    annotation.userInfo = self.routePoints;
    [mapView addAnnotation:annotation];

    
    [self.view addSubview:mapView];
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{
    if (annotation.isUserLocationAnnotation)
        return nil;

    RMShape *shape = [[RMShape alloc] initWithView:mapView];
    shape.lineColor = [UIColor colorWithRed:0.224 green:0.671 blue:0.780 alpha:0.5];
    shape.lineWidth = 8.0;

    shape.lineJoin = @"round";
    shape.lineCap = @"round";
    
    for (SimpleKMLLineString * lineString in self.routePoints) {
        for (int i =0; i < lineString.coordinates.count; i++){

            CLLocation *coordinate = (CLLocation *)lineString.coordinates[i];
            if (i == 0) {
                [shape moveToCoordinate:coordinate.coordinate];
            } else{
        
                [shape addLineToCoordinate:coordinate.coordinate];
            }
        }
    }


    return shape;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
