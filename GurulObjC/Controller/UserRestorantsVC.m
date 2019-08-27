//
//  UserRestorantsVC.m
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "UserRestorantsVC.h"
#import "AppDelegate.h"
#import "ViewController.h"
@import Firebase;

@interface UserRestorantsVC ()

@end

@implementation UserRestorantsVC
@synthesize tableView;
@synthesize restorantNames;//Adları
@synthesize referance;
@synthesize restorantExplain;// Açıklamaları
@synthesize restIDS;// ID
@synthesize restoranURL; // RestorantURL
@synthesize restArray;//General Type

- (void)viewDidLoad {
    [super viewDidLoad];
    self->restorantNames = [[NSMutableArray alloc]init];
    self->restorantExplain = [[NSMutableArray alloc]init];
    self->restoranURL = [[NSMutableArray alloc]init];
    self->restIDS = [[NSMutableArray alloc]init];
    [self setRestorantNames:self->restorantNames];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self->tableView registerNib:[UINib  nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}
//MARK: - TableView Sources
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Cell *customCell = (Cell*)[self->tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (customCell != nil){
        if(self->restorantNames.count > 0){
            customCell.RestName.text = self->restorantNames[indexPath.row];
            customCell.RestExplain.text = self->restorantExplain[indexPath.row];  
        }
    }
    return customCell;
//    UITableViewCell *cell = [[UITableViewCell alloc]init];
//    if(self->restorantNames.count > 0){
//        cell.textLabel.text = self->restorantNames[indexPath.row];
//    }
//    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSURL* url = [[NSURL alloc] initWithString: self->restoranURL[indexPath.row]];
    [[UIApplication sharedApplication] openURL: url];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self->restorantNames.count == 0){
        return 0;
    }else {
        return self->restorantNames.count;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        // eğer silme işlemi var ise
        self->referance = [[FIRDatabase database] reference];
        [[[self->referance child:@"Restorants"]child:self->restIDS[indexPath.row]] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if(error == nil){
                [self->restIDS removeObjectAtIndex:indexPath.row];
                [self->restorantNames removeObjectAtIndex:indexPath.row];
                [self->restorantExplain removeObjectAtIndex:indexPath.row];
                [self->tableView reloadData];
            }
        }];
          
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}
//
- (void)setRestorantNames:(NSMutableArray *)restorantNames{
    self->referance = [[FIRDatabase database]reference];
    [[self->referance child:@"Restorants"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot.value[@"senderID"] isEqualToString:[FIRAuth auth].currentUser.uid]){
            // GeneralType Kullanılabilir.
            [self->restIDS addObject:snapshot.key];
            [restorantNames addObject:snapshot.value[@"restorantName"]];
            [self->restorantExplain addObject:snapshot.value[@"addtional"]];
            [self->restoranURL addObject:snapshot.value[@"restorantYemekSepeti"]];
            [self->tableView reloadData];
        }
    }];
}
- (IBAction)LogoutBtn:(id)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }else{
        NSLog(@"Successfully Signout");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
         AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [UIView transitionWithView:appDel.window
                          duration:1.5
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^{
                            ViewController  * hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"girisVC"];

                            appDel.window.rootViewController = hvc;
                        } completion:nil];
       
       // [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)redirectToMapView:(id)sender {
    [self performSegueWithIdentifier:@"toMapVC" sender:nil];
}
@end
