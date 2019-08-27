//
//  ProfilVC.h
//  GurulObjC
//
//  Created by Mac on 23.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@import Firebase;
@import FirebaseStorage;

NS_ASSUME_NONNULL_BEGIN

@interface ProfilVC : SuperViewController<UINavigationControllerDelegate , UIImagePickerControllerDelegate>
- (IBAction)logoutbuttonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *emailAccount;
@property (weak, nonatomic) IBOutlet UIImageView *userimageView;

@property (strong , nonatomic) FIRDatabaseReference *referance;
@property (strong , nonatomic) FIRStorageReference *storageReferance;


@end

NS_ASSUME_NONNULL_END
