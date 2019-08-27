//
//  AppDelegate.h
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)segueAfterSave;
- (BOOL)connected;
-(void)checkUser;
@end

