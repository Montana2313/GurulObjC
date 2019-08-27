//
//  RestorantDetailVC.h
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface RestorantDetailVC : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    CLLocation *location;
    NSMutableArray *RegionarrayPickerView;
    NSMutableArray *FoodTypearrayPickerView;
    NSString *selectedFromPickerView;
    NSString *CountryName;
    NSMutableArray *selectedFromPickerViewByFOOD;
}
- (IBAction)backButtonTapped:(id)sender;


@property (nonatomic, retain) CLLocation *location;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)  CLLocationManager *manager;
@property (weak, nonatomic) IBOutlet UITextField *placeName;
@property (weak, nonatomic) IBOutlet UITextField *yemekSepetiLink;
@property (weak, nonatomic) IBOutlet UITextView *addtional;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong , nonatomic) FIRDatabaseReference *referance;
@property (nonatomic,retain) NSMutableArray *RegionarrayPickerView;
@property (nonatomic,retain) NSMutableArray *selectedFromPickerViewByFOOD;
@property (nonatomic,retain) NSMutableArray *FoodTypearrayPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewfoodTYpe;


-(void)setTakeCoordinate:(CLLocation*)loc;
- (IBAction)saveBtnTapped:(id)sender;

@end

NS_ASSUME_NONNULL_END
