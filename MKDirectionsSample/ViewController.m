//
//  ViewController.m
//  MKDirectionsSample
//
//  Created by koogawa on 2013/12/02.
//  Copyright (c) 2013年 Kosuke Ogawa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 地図の中心・表示範囲を設定
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(35.665213, 139.730011);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.08, 0.08);
    self.mapView.region = MKCoordinateRegionMake(centerCoordinate, span);
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    // 六本木
    CLLocationCoordinate2D fromCoordinate = CLLocationCoordinate2DMake(35.665213, 139.730011);

    // 渋谷
    CLLocationCoordinate2D toCoordinate = CLLocationCoordinate2DMake(35.658987, 139.702776);

    // CLLocationCoordinate2D から MKPlacemark を生成
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate
                                                       addressDictionary:nil];
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toCoordinate
                                                       addressDictionary:nil];

    // MKPlacemark から MKMapItem を生成
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];

    // MKMapItem をセットして MKDirectionsRequest を生成
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = fromItem;
    request.destination = toItem;
    request.requestsAlternateRoutes = YES;

    // MKDirectionsRequest から MKDirections を生成
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];

    // 経路検索を実行
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
     {
         if (error) return;

         if ([response.routes count] > 0)
         {
             MKRoute *route = [response.routes objectAtIndex:0];
             NSLog(@"distance: %.2f meter", route.distance);

             // 地図上にルートを描画
             [self.mapView addOverlay:route.polyline];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MKMapViewDelegate

// 地図上に描画するルートの色などを指定（これを実装しないと何も表示されない）
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.lineWidth = 5.0;
        routeRenderer.strokeColor = [UIColor redColor];
        return routeRenderer;
    }
    else {
        return nil;
    }
}

@end
