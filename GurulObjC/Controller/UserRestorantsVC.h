//
//  UserRestorantsVC.h
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"
#import "GeneralTypes.m"
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface UserRestorantsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *restorantNames;
    NSMutableArray *restorantExplain;
    NSMutableArray *restorantURL;
    NSMutableArray *restIDS;
    NSMutableArray<GeneralType *> *classRest;
}
- (IBAction)LogoutBtn:(id)sender;
- (IBAction)redirectToMapView:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *restorantNames;
@property (nonatomic,retain) NSMutableArray *restorantExplain;
@property (nonatomic,retain) NSMutableArray *restoranURL;
@property (nonatomic,retain) NSMutableArray *restIDS;
@property (nonatomic,retain) NSMutableArray<GeneralType *> *restArray;


@property (strong , nonatomic) FIRDatabaseReference *referance;



@end

NS_ASSUME_NONNULL_END
