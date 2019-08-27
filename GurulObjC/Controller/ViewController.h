//
//  ViewController.h
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@import Firebase;

@interface ViewController : SuperViewController{
    NSString *choosen;
}
@property (weak, nonatomic) IBOutlet UIButton *RestSignButton;
@property (weak, nonatomic) IBOutlet UIButton *RestListButton;
@property (weak, nonatomic) IBOutlet UIButton *ViewInMap;

@property (strong , nonatomic) FIRDatabaseReference *referance;

@end

