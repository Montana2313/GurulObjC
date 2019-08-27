//
//  ProfilVC.m
//  GurulObjC
//
//  Created by Mac on 23.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "ProfilVC.h"
#import "AppDelegate.h"
#import "ViewController.h"
@import Firebase;
@import SVProgressHUD;
@import SDWebImage;

@interface ProfilVC ()

@end

@implementation ProfilVC
@synthesize userimageView;
@synthesize referance;
@synthesize storageReferance;
@synthesize emailAccount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getImage];
    self.navigationController.navigationBar.hidden = YES;
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(50, 50, 300, 250);
   // button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(picker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.emailAccount.text = [[FIRAuth auth]currentUser].email;
}
-(void)getImage{
    self->referance = [FIRDatabase database].reference;
    [[[self->referance child:@"RestOwnerImages"] child:[FIRAuth auth].currentUser.uid]observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        printf("%s", snapshot.value);
        NSURL *url = [[NSURL alloc] initWithString:snapshot.value];
        [self.userimageView sd_setImageWithURL:url];
        self.userimageView.layer.cornerRadius = self.userimageView.frame.size.width / 2;
        self.userimageView.contentMode = UIViewContentModeScaleToFill;
        self.userimageView.clipsToBounds = YES;
        self.userimageView.layer.masksToBounds = YES;
        self.userimageView.layer.borderWidth=5.0;
    }];
}
-(void)picker{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
  //  controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.userimageView.image = chosenImage;
//    self.userimageView.sizeToFit;
    self.userimageView.layer.cornerRadius= self.userimageView.bounds.size.width / 2.0;
    self.userimageView.layer.borderWidth=2.0;
    self.userimageView.layer.masksToBounds = YES;
    
    // Firebase ekleme işlemi
    self->referance = [[FIRDatabase database]reference];
    self->storageReferance = [[FIRStorage storage] reference];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *str = [NSString stringWithFormat: @"%@.jpg", uuid];
    NSData * data  =  UIImageJPEGRepresentation(self.userimageView.image, 0.5);
    [SVProgressHUD show];
    [[[self->storageReferance child:@"media"] child:str] putData:data metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if(error == nil){
            [[[self->storageReferance child:@"media"] child:str] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error == nil){
                    NSDictionary *setValueDic = @{@"imageURL":URL.absoluteString
                                                   };
                    [[[self->referance child:@"RestOwnerImages"] child:[FIRAuth auth].currentUser.uid] setValue:setValueDic];
                    [SVProgressHUD dismiss];
                }else {
                    printf("%s error download", error.localizedDescription);
                }
            }];
        }else {
            printf("%s error upload ", error.localizedDescription);
        }
    }];
    
//    [self->storageReferance child:@"media"]
    // buradan restowner çekilip güncelleme yapıalcak
//    [[self->referance child:@"RestOwnerImages"] child:[FIRAuth auth].currentUser.uid];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logoutbuttonTapped:(id)sender {
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
@end
