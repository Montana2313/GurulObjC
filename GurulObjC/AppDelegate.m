//
//  AppDelegate.m
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "UserRestorantsVC.h"
#import "Reachability.h"
@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
      [self checkUser];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}
-(void)segueAfterSave{
    UserRestorantsVC *restVC = [[UserRestorantsVC alloc] init];
    self.window.rootViewController = restVC;
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
#pragma mark : - Shake Func
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake )
    {
        // shaking has began.
        NSLog(@"he");
    }
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake )
    {
        // shaking has began.
         NSLog(@"he2 ");
    }
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
-(void)checkUser{
    if([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"user"]){
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
//        NSLog(@"Silindi");
        NSMutableArray *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        [[FIRAuth auth] signInWithEmail:user[0] password:user[1] completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if(error == nil){
            }
        }];
        //UserRestorantsVC *userRest = [[UserRestorantsVC alloc] init];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil]; //My storyboard name is Main.storyboard
        UserRestorantsVC * hvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ProfilVC"];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:hvc];
        [self.window makeKeyAndVisible];

    }else {
        NSLog(@"user mevcut değil");
    }
}

@end
