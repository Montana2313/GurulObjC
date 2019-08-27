//
//  ViewController.m
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "ViewController.h"
#import "AfterShake.h"
#import "AppDelegate.h"
#include <stdlib.h>
@import Firebase;
@import SVProgressHUD;

@interface ViewController ()


@end

@implementation ViewController
@synthesize referance;
@synthesize RestListButton;
@synthesize RestSignButton;
@synthesize ViewInMap;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [self createUserwith:@"ozgur968@gmail.com" password:@"montana2313"];
   // [self createFoodType];
   // [self createplaceMark];
   // [self createRestorants]; Enlem ve boylamda bir sıkıntı var
}
- (void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBar.hidden = YES;
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if(![appDel connected]){
        self->RestSignButton.enabled = NO;
        self->RestListButton.enabled = NO;
        self->ViewInMap.enabled = NO;
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Bilgi" message:@"İnternet bağlantısı yok" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Tamam" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            while ([appDel connected] == NO) {
                NSLog(@"Hala internet yok");
            }
            NSLog(@"İnternet Var");
            self->RestSignButton.enabled = YES;
            self->RestListButton.enabled = YES;
            self->ViewInMap.enabled = YES;
        }];
        [controller addAction:okButton];
        [self presentViewController:controller animated:YES completion:nil];
    }
}
//MARK: - Test Verileri için
-(void)createUserwith:(NSString*)username password:(NSString*)password{
    [[FIRAuth auth] createUserWithEmail:username password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if(error == nil){
            NSDictionary *dict = @{@"userID":authResult.user.uid,@"usermail":username,@"userpassword":password};
        
           self.referance = [[FIRDatabase database] reference];
            [[[self.referance child:@"restowner"] childByAutoId] setValue:dict];
        }
    }];
}
//MARK: - Test verileri kayıt işlemleri
-(void)createFoodType{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@"Börek"];
    [array addObject:@"Balık&Deniz Ürünleri"];
    [array addObject:@"Çiğ Köfte"];
    [array addObject:@"Döner"];
    [array addObject:@"Kokoreç"];
    [array addObject:@"Pide"];
    [array addObject:@"Steak"];
    [array addObject:@"Burger"];
    [array addObject:@"Çin Mutfağı"];
    [array addObject:@"Kumpir"];
    [array addObject:@"Pilav"];
    [array addObject:@"Tantuni"];
    [array addObject:@"Kebap"];
    [array addObject:@"Tavuk"];
    [array addObject:@"Pizza"];
    [array addObject:@"Köfte"];
    [array addObject:@"Ev Yemekleri"];
    [array addObject:@"Tatlı"];
    [array addObject:@"Fast&Food Sandiviç"];
    self.referance = [[FIRDatabase database]reference];
    [[[self.referance child:@"FoodType"]childByAutoId]setValue:array];
}
-(void)createplaceMark{
    self.referance = [[FIRDatabase database]reference];
    NSString *uuid = (NSString*)[[NSUUID UUID] UUIDString];
    NSDictionary *array = @{@"placeName":@"Şişli",@"id":uuid,@"city":@"İstanbul"};
    [[[self.referance child:@"Regions"]child:uuid]setValue:array];
}
-(void)createRestorants{
    self->referance = [[FIRDatabase database]reference];
 
    NSDictionary *setValueDic = @{@"restorantName":@"Aslı börek",
    @"restorantYemekSepeti":@"https://www.yemeksepeti.com/asli-borek-sisli-mesrutiyet-mah-nisantasi-istanbul",
                                  @"addtional":@"Kıymalı börek , peynirli börek önerimizdir.",
                                  @"region":@"Şişli",
                                  @"enlem":@(41.05),
                                  @"boylam":@(28.98),
                                  @"foodType":@"Börek",
                                  @"senderID": [FIRAuth auth].currentUser.uid
                                  };
    [[[self->referance child:@"Restorants"]childByAutoId] setValue:setValueDic];
}
//MARK: - Shake işlemleri
-(BOOL)canBecomeFirstResponder {
    return YES;
}


-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake )
    {
        NSLog(@"Shake algılandı");
        
    }
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake )
    {
        [SVProgressHUD show];
        if([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"randomValue"]){
            NSNumber *savedValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"randomValue"];
            [self fetchFoodType:savedValue];
        }else {
            [self fetchFoodType:nil];
        }
    }
}
-(void)fetchFoodType:(nullable NSNumber*)randomvalue{
    self.referance = [[FIRDatabase database]reference];
    [[self.referance child:@"FoodType"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *foodType = [[NSMutableArray alloc]init];
        foodType = (NSMutableArray*)snapshot.value;
        int count = (int)[foodType count];
        int random = (int)arc4random_uniform(count);
        if(randomvalue == nil){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSNumber numberWithInteger:random] forKey:@"randomValue"];
            [defaults synchronize];
        }else {
            while (randomvalue.integerValue == random) {
                // eğer bunlar eşit ise üretmeye deva et
                random =(int)arc4random_uniform(count);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[NSNumber numberWithInteger:random] forKey:@"randomValue"];
                [defaults synchronize];
            }
        }
        self->choosen = foodType[random];
        [SVProgressHUD dismiss];
        // veriler geldi buradan aktarma yapılacak
            [self performSegueWithIdentifier:@"afterShake" sender:nil];
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"afterShake"]){
        AfterShake *shakeView = [segue destinationViewController];
        [shakeView setChoosenType:self->choosen];
    }
}


@end
