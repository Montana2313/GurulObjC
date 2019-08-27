//
//  ShowMapVC.m
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "ShowMapVC.h"
@import Firebase;

@interface ShowMapVC ()

@end

@implementation ShowMapVC
@synthesize mapkit;
@synthesize manager;
@synthesize LocationLatitude;
@synthesize LocationLongtitude;
@synthesize referance;


- (void)viewDidLoad {
    [super viewDidLoad];
    self->LocationLatitude = [[NSMutableArray alloc]init];
    self->LocationLongtitude = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.hidden = NO;
    [self configMapview];
    [self setRestorants];
}
-(void)configMapview{
    mapkit.delegate = self;
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    
    manager.desiredAccuracy = kCLLocationAccuracyBest; // en iyi lokasyon verisi
    [manager requestWhenInUseAuthorization];
    self.mapkit.showsUserLocation = YES;
    [manager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(locations[0].coordinate.latitude, locations[0].coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    [self.mapkit setRegion:region animated:YES];
}
-(void)setRestorants{
    self->referance = [[FIRDatabase database]reference];
    [[self->referance child:@"Restorants"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake([snapshot.value[@"enlem"] doubleValue],[snapshot.value[@"boylam"] doubleValue]);
        annotation.title = snapshot.value[@"restorantName"];
        if(snapshot.value[@"foodType"] != nil){
             annotation.subtitle = snapshot.value[@"foodType"];
        }else if (snapshot.value[@"foodTYPEarray"] !=nil){
            NSMutableArray *array = snapshot.value[@"foodTYPEarray"];
            annotation.subtitle = array[0];
        }
        [self.mapkit addAnnotation:annotation];
    }];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:MKUserLocation.class]){
        return nil;
    }
    MKAnnotationView *pinview = [self.mapkit dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if(pinview == nil){
        pinview = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        pinview.canShowCallout = YES;
        UIButton *calloutButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        pinview.rightCalloutAccessoryView = calloutButton;
    }else {
        pinview.annotation = annotation;
    }
    if ([annotation.subtitle isEqualToString:@"Pizza"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pizza.png"]];
        [pinview addSubview:image];
    }else if ([annotation.subtitle isEqualToString:@"Burger"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"burger.png"]];
        [pinview addSubview:image];
    }else if ([annotation.subtitle isEqualToString:@"Balık&Deniz Ürünleri"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"balik.png"]];
        [pinview addSubview:image];
    }else if ([annotation.subtitle isEqualToString:@"Tatlı"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tatli.png"]];
        [pinview addSubview:image];
    }else if ([annotation.subtitle isEqualToString:@"Çin Mutfağı"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sushi.png"]];
        [pinview addSubview:image];
    }else if ([annotation.subtitle isEqualToString:@"Tavuk"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tavuk.png"]];
        [pinview addSubview:image];
    }else if ([annotation.subtitle isEqualToString:@"Steak"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"steak.png"]];
        [pinview addSubview:image];
    } else if ([annotation.subtitle isEqualToString:@"Pide"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pide.png"]];
        [pinview addSubview:image];
    } else if ([annotation.subtitle isEqualToString:@"Pilav"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pilav.png"]];
        [pinview addSubview:image];
    } else if ([annotation.subtitle isEqualToString:@"Kokorç"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"koko.png"]];
        [pinview addSubview:image];
    } else if ([annotation.subtitle isEqualToString:@"Döner"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doner.png"]];
        [pinview addSubview:image];
    } else if ([annotation.subtitle isEqualToString:@"Ev Yemekleri"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"evYemek.png"]];
        [pinview addSubview:image];
    }else if ([annotation.subtitle isEqualToString:@"Kebap"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kebap.png"]];
        [pinview addSubview:image];
    }else if ([annotation.subtitle isEqualToString:@"Köfte"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Kofte.png"]];
        [pinview addSubview:image];
    } else if ([annotation.subtitle isEqualToString:@"Kumpir"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kumpir.png"]];
        [pinview addSubview:image];
    }else if ([annotation.subtitle isEqualToString:@"Çiğ Köfte"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cKofte.png"]];
        [pinview addSubview:image];
    }else if ([annotation.subtitle isEqualToString:@"Fast&Food Sandiviç"]){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subway.png"]];
        [pinview addSubview:image];
    }
    return pinview;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
    CLGeocoder *clg = [[CLGeocoder alloc] init];
  
    [clg reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(placemarks.count > 0){
            MKPlacemark *navPlaceMark = [[MKPlacemark alloc] initWithPlacemark:placemarks[0]];
            MKMapItem *navMapItem = [[MKMapItem alloc]initWithPlacemark:navPlaceMark];
            [navMapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
          
        }
    }];
}
@end
