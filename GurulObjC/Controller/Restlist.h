//
//  Restlist.h
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Cell.h"
NS_ASSUME_NONNULL_BEGIN

@interface Restlist : UIViewController<UITableViewDelegate , UITableViewDataSource>{
    NSMutableArray *arrayRestName;
    NSMutableArray *arrayRestURL;
    NSMutableArray *arrayNameExplain;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain , nonatomic) NSMutableArray *arrayRestName;
@property (retain , nonatomic) NSMutableArray *arrayRestURL;
@property (retain , nonatomic) NSMutableArray *arrayNameExplain;

@property (strong , nonatomic) FIRDatabaseReference *referance;

@end

NS_ASSUME_NONNULL_END
