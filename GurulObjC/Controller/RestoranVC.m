//
//  RestoranVC.m
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "RestoranVC.h"
#import "RestorantDetailVC.h"
@import Firebase;

@interface RestoranVC ()

@end

@implementation RestoranVC
@synthesize mapkit;
@synthesize manager;
@synthesize coordinateLat;
@synthesize coordinateLong;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Bilgi" message:@"Haritada restoranınızın yerini gösteriniz" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Tamam" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * _Nonnull action) {
        [self configMapview];
    }];
    [controller addAction:okButton];
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [self->mapkit removeAnnotations:self->mapkit.annotations];
}
-(void)configMapview{
    mapkit.delegate = self;
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    
    manager.desiredAccuracy = kCLLocationAccuracyBest; // en iyi lokasyon verisi
    [manager requestWhenInUseAuthorization];
    self.mapkit.showsUserLocation = YES;
    [manager startUpdatingLocation];
    UILongPressGestureRecognizer *gestureRecognaizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(whenUserLongPress:)];
    gestureRecognaizer.minimumPressDuration = 2;
    [self.mapkit addGestureRecognizer:gestureRecognaizer];
}
-(void)whenUserLongPress:(UILongPressGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        CGPoint touchpoint = [gesture locationInView:mapkit];
        CLLocationCoordinate2D coordinate = [self.mapkit convertPoint:touchpoint toCoordinateFromView:self.mapkit];
        self->coordinateLat = [NSString stringWithFormat:@"%f", coordinate.latitude];
        self->coordinateLong =[NSString stringWithFormat:@"%f", coordinate.longitude];
//         CLLocation *LOC = [[CLLocation alloc]initWithLatitude:self->coordinateLat.doubleValue    longitude:self->coordinateLong.doubleValue];
        MKPointAnnotation *annotaion = [[MKPointAnnotation alloc] init];
        annotaion.coordinate = coordinate;
        annotaion.title = @"Seçtiğiniz yer";
        [self.mapkit addAnnotation:annotaion];
//        RestorantDetailVC *restoran = [[RestorantDetailVC alloc] init];
//        [self presentViewController:restoran animated:YES completion:^{
//            [restoran setTakeCoordinate:LOC];
//        }];
        [self performSegueWithIdentifier:@"forDetail" sender:nil];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"forDetail"]){
        UINavigationController *navController = [segue destinationViewController];
        RestorantDetailVC *restoran = (RestorantDetailVC *)([navController topViewController]);
        CLLocation *LOC = [[CLLocation alloc]initWithLatitude:self->coordinateLat.doubleValue    longitude:self->coordinateLong.doubleValue];
       [restoran setTakeCoordinate:LOC];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(locations[0].coordinate.latitude, locations[0].coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    [self.mapkit setRegion:region animated:YES];
}
@end
