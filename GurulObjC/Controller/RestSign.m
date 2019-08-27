//
//  RestSign.m
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "RestSign.h"
@import Firebase;
@import SVProgressHUD;

@interface RestSign ()

@end

@implementation RestSign

@synthesize textID;
@synthesize passwordText;
@synthesize referance;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 30, 15, 30);
    [button addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
   
    self->passwordText.secureTextEntry = YES;
}
-(void)backButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewTapped:(UITapGestureRecognizer*)sender{
    [self.view endEditing:YES];
}

- (IBAction)signInBtn:(id)sender {
    if([self.textID.text  isEqualToString: @""] == NO && [self.passwordText.text isEqualToString:@""] == NO)
    {
        // textID user
        [SVProgressHUD show];
        [[FIRAuth auth] signInWithEmail:self.textID.text password:self.passwordText.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if(error == nil){
                [SVProgressHUD dismiss];
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:self->textID.text];
                [array addObject:self->passwordText.text];
                self.textID.text = @"";
                self.passwordText.text = @"";
          
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:array forKey:@"user"];
                [defaults synchronize];
                [self performSegueWithIdentifier:@"restside" sender:nil];
            }else {
                [SVProgressHUD dismiss];
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Bilgi" message:@"Girilen ID yanlış.Lütfen kontrol ediniz." preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Tamam" style:UIAlertActionStyleCancel handler:nil];
                [controller addAction:okButton];
                [self presentViewController:controller animated:YES completion:nil];
            }
        }];
        //BURADA USERID Ye göre giriş sağlanmaktadır
//        [self checkUserwithComplition:^(bool userexits) {
//            if(userexits == YES){
//                NSLog(@"user mevcut");
//                [SVProgressHUD dismiss];
//                [self performSegueWithIdentifier:@"restside" sender:nil];
//            }else {
//                [SVProgressHUD dismiss];
//                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Bilgi" message:@"Girilen ID yanlış.Lütfen kontrol ediniz." preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Tamam" style:UIAlertActionStyleCancel handler:nil];
//                [controller addAction:okButton];
//                [self presentViewController:controller animated:YES completion:nil];
//            }
//        }];
    }
    else
    {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Bilgi" message:@"Boş alanlar mevcut" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Tamam" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:okButton];
        [self presentViewController:controller animated:YES completion:nil];
    }
}
-(void)checkUserwithComplition:(void(^)(bool userexits))complitionBlock{
    self.referance = [[FIRDatabase database] reference];
    [self.referance observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *value = (NSDictionary *)snapshot.value;
        for (NSString *stringıd in value.allKeys){
            NSDictionary *coming = value[stringıd];
            NSString *username = [coming objectForKey:@"userID"];
            NSString *password = [coming objectForKey:@"userpassword"];
            if([username isEqualToString:self.textID.text] == YES && [password isEqualToString:self.passwordText.text] == YES){
                // Giriş yapılıyor
                [[FIRAuth auth] signInWithEmail:[coming objectForKey:@"usermail"] password:password completion:nil];
                complitionBlock(YES);
            }
        }
        complitionBlock(NO);
        
    }];
    
}
@end
