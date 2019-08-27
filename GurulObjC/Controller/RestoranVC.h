//
//  RestoranVC.h
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface RestoranVC : ViewController<MKMapViewDelegate,CLLocationManagerDelegate>{
    NSString*coordinatelat ;
    NSString*coordinateLong;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapkit;
@property (strong, nonatomic)  CLLocationManager *manager;
@property (nonatomic) NSString *coordinateLat;
@property (nonatomic) NSString *coordinateLong;


@end

NS_ASSUME_NONNULL_END
