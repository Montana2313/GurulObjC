//
//  RestSign.h
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "SuperViewController.h"

@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface RestSign : SuperViewController
@property (weak, nonatomic) IBOutlet UITextField *textID;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (strong , nonatomic) FIRDatabaseReference *referance;
- (IBAction)signInBtn:(id)sender;

@end

NS_ASSUME_NONNULL_END
