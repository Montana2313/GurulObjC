//
//  AfterShake.h
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ViewController.h"
#import "Cell.h"


NS_ASSUME_NONNULL_BEGIN

@interface AfterShake : UIViewController<UITableViewDelegate , UITableViewDataSource,CLLocationManagerDelegate>{
    NSString *ChoosenFoodType;
    NSMutableArray *arrayNames;
    NSMutableArray *arrayURLs;
    NSMutableArray *arrayNameExplain;
    double enlem;
    double boylam;
    __weak IBOutlet UILabel *ChoosenTExt;
    __weak IBOutlet UITableView *tablewView;
}

-(void) setChoosenType:(NSString*)type;
@property (nonatomic , retain) NSMutableArray *arrayNames;
@property (nonatomic , retain) NSMutableArray *arrayURLs;
@property (nonatomic , retain) NSMutableArray *arrayNameExplain;
@property (strong , nonatomic) FIRDatabaseReference *referance;
@property (strong, nonatomic)  CLLocationManager *manager;
@end

NS_ASSUME_NONNULL_END
