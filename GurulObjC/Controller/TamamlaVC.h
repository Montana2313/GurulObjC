//
//  TamamlaVC.h
//  GurulObjC
//
//  Created by Mac on 24.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface TamamlaVC : UIViewController<UITableViewDelegate , UITableViewDataSource>{
    NSMutableArray *foodArrayType;
    NSMutableArray *selectedFoodType;
    CLLocation *location;
    NSString *restName;
    NSString *restYemekSepeti;
    NSString *addtional;
    NSString *countryName;
  
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)tamamlaButton:(id)sender;
@property (strong , nonatomic) FIRDatabaseReference *referance;
@property (nonatomic , retain) NSMutableArray *foodArrayType;
@property (nonatomic , retain) NSMutableArray *selectedFoodType;


-(void)setTakeCoordinate:(CLLocation*)loc;
-(void)other:(NSString*)RestName restLink:(NSString*)yemeksepetiLink addtional:(NSString*)addtional;
-(void)andCounryNanm:(NSString*)withName;
@end

NS_ASSUME_NONNULL_END
