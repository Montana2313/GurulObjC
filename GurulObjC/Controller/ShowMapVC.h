//
//  ShowMapVC.h
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface ShowMapVC : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>{
    NSMutableArray *LocationLatitude;
    NSMutableArray *LocationLongtitude;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapkit;
@property (strong, nonatomic)  CLLocationManager *manager;
@property (nonatomic,retain) NSMutableArray *LocationLatitude;
@property (nonatomic,retain) NSMutableArray *LocationLongtitude;
@property (strong , nonatomic) FIRDatabaseReference *referance;

@end

NS_ASSUME_NONNULL_END
