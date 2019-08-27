//
//  TamamlaVC.m
//  GurulObjC
//
//  Created by Mac on 24.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "TamamlaVC.h"
#import "UserRestorantsVC.h"
#import "AppDelegate.h"
@import Firebase;
@import SVProgressHUD;


@interface TamamlaVC ()

@end

@implementation TamamlaVC
@synthesize tableView;
@synthesize foodArrayType;
@synthesize referance;
@synthesize selectedFoodType;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loodFoodTypes];
    self->selectedFoodType = [[NSMutableArray alloc] init];
    self->tableView.delegate = self;
    self->tableView.dataSource = self;
}
- (void)setTakeCoordinate:(CLLocation*)loc{
    self->location = loc;
}- (void)other:(NSString*)RestName restLink:(NSString*)yemeksepetiLink addtional:(NSString*)addtional {
    self->restName = RestName;
    self->restYemekSepeti = yemeksepetiLink;
    self->addtional = addtional;
}
-(void)andCounryNanm:(NSString*)withName{
    // veri gerçek cihaz da geliyor sadece
    self->countryName = withName;
}
-(void)loodFoodTypes{
    self.referance = [[FIRDatabase database]reference];
    [[self->referance child:@"FoodType"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self->foodArrayType = [snapshot.value mutableCopy];
        [self.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"];
        }
        if(self->foodArrayType.count > 0){
            cell.textLabel.text = self.foodArrayType[indexPath.row];
        }else {
            cell.textLabel.text = @"Veri bulamadık.";
        }
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self->selectedFoodType removeObject:self.foodArrayType[indexPath.row]];
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self->selectedFoodType addObject:self.foodArrayType[indexPath.row]];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self->foodArrayType.count == 0){
        return 1;
    }else {
        return self->foodArrayType.count;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}
//
- (void)setRestorantNames:(NSMutableArray *)restorantNames{
    self->referance = [[FIRDatabase database]reference];
    
}

- (IBAction)tamamlaButton:(id)sender {
    // bu işlem tamam sadece after shake kontrolü kaldı
        [SVProgressHUD show];
    if(self.selectedFoodType.count == 0){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Bilgi" message:@"Yemek Türünüzü Seçiniz." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Tamam" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:okButton];
        [SVProgressHUD dismiss];
        [self presentViewController:controller animated:YES completion:nil];
        
    }else {
        self->referance = [[FIRDatabase database]reference];
        NSDictionary *setValueDic = @{@"restorantName":self->restName,
                                      @"restorantYemekSepeti":self->restYemekSepeti,
                                      @"addtional":self->addtional,
                                      @"region":self->countryName,
                                      @"enlem":@(self->location.coordinate.latitude),
                                      @"boylam":@(self->location.coordinate.longitude),
                                      @"foodTYPEarray":self.selectedFoodType,
                                      @"senderID": [FIRAuth auth].currentUser.uid
                                      };
        [[[self->referance child:@"Restorants"]childByAutoId] setValue:setValueDic];
        [SVProgressHUD dismiss];
        TamamlaVC * hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilVC"];
        AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDel.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:hvc];
    }
}
@end
