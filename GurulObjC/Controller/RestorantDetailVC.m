//
//  RestorantDetailVC.m
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "RestorantDetailVC.h"
#import "AppDelegate.h"
#import "UserRestorantsVC.h"
#import "TamamlaVC.h"

@import Firebase;
@import SVProgressHUD;
@import AFNetworking;

@interface RestorantDetailVC ()

@end

@implementation RestorantDetailVC
@synthesize mapView;
@synthesize manager;
@synthesize location;
@synthesize placeName;
@synthesize addtional;
@synthesize yemekSepetiLink;
@synthesize pickerView;
@synthesize pickerViewfoodTYpe;
@synthesize referance;
@synthesize RegionarrayPickerView;
@synthesize FoodTypearrayPickerView;
@synthesize selectedFromPickerViewByFOOD;
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingView:)];
    [self.view addGestureRecognizer:tapGesture];
    self->RegionarrayPickerView = [[NSMutableArray alloc] init];
    self->FoodTypearrayPickerView = [[NSMutableArray alloc]init];
    self->selectedFromPickerViewByFOOD = [[NSMutableArray alloc] init];
    [self configMapview];
    
    self->pickerView.delegate = self;
    self->pickerView.dataSource = self;
    // eğer picker ile kayıt yapılmak istenirse bunlar silinmesi yeterli.
    self->pickerView.hidden = true;
    self->pickerViewfoodTYpe.hidden = true;
    self->pickerViewfoodTYpe.delegate = self;
    self->pickerViewfoodTYpe.dataSource = self;
 
    [self loadpickerViewRegion];
    [self loadpickerViewFoodType];
}
-(void)endEditingView:(UITapGestureRecognizer*)reco{
    [self.view endEditing:YES];
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerViewCome numberOfRowsInComponent:(NSInteger)component {
    if(pickerViewCome == self->pickerView){
        if (self->RegionarrayPickerView.count == 0 ){
            return 0;
        }else {
            return self->RegionarrayPickerView.count;
        }
    }
    if(pickerViewCome == self->pickerViewfoodTYpe){
        if (self->FoodTypearrayPickerView.count == 0 ){
            return 0;
        }else {
            return self->FoodTypearrayPickerView.count;
        }
    }

    return 0;
   
}
- (void)pickerView:(UIPickerView *)ThepickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(ThepickerView == self->pickerView){
         self->selectedFromPickerView = self->RegionarrayPickerView[row];
    }
    if(ThepickerView == self->pickerViewfoodTYpe){
        if(self->selectedFromPickerViewByFOOD.count >= 3){
            // 3 den büyük ise ilk eleman silinir
            [self->selectedFromPickerViewByFOOD removeObjectAtIndex:0];
            [self.selectedFromPickerViewByFOOD addObject:self->FoodTypearrayPickerView[row]];
        }else {
            [self.selectedFromPickerViewByFOOD addObject:self->FoodTypearrayPickerView[row]];
        }
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (thePickerView == self->pickerView){
         return [self->RegionarrayPickerView objectAtIndex:row];
    }
    if(thePickerView == self->pickerViewfoodTYpe){
         return [self->FoodTypearrayPickerView objectAtIndex:row];
    }
    return @"";
}
-(void)loadpickerViewRegion{
    self.referance = [[FIRDatabase database]reference];
    [[self->referance child:@"Regions"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [self->RegionarrayPickerView addObject:snapshot.value[@"placeName"]];
        [self.pickerView reloadAllComponents];
    }];
}
-(void)loadpickerViewFoodType{
    self.referance = [[FIRDatabase database]reference];
    [[self->referance child:@"FoodType"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self->FoodTypearrayPickerView = [snapshot.value mutableCopy];
        [self.pickerViewfoodTYpe reloadAllComponents];
    }];
}
- (void)setTakeCoordinate:(CLLocation*)loc{
    self->location = loc;
}

- (IBAction)saveBtnTapped:(id)sender {
    [SVProgressHUD show];
    if([self->placeName.text isEqualToString:@""] || [self->yemekSepetiLink.text isEqualToString:@""] || [self->selectedFromPickerView isEqualToString:@""]){
        [SVProgressHUD dismiss];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Bilgi" message:@"Boş alanlar mevcut" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Tamam" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:okButton];
        [self presentViewController:controller animated:YES completion:nil];
    }else {
        if([self->yemekSepetiLink.text containsString:@"www.yemeksepeti.com"]){
            if(self->selectedFromPickerViewByFOOD.count != 3){
                while (self->selectedFromPickerViewByFOOD.count != 3) {
                    // eğer hiç oynatılmamış ise yada bir 2 tane 1 tane seçim yapıldı ise sonrasına hep börek eklemesi yapıladcak
                    [self.selectedFromPickerViewByFOOD addObject:@"Börek"];
                }
            }
            [self createTask];
            [SVProgressHUD dismiss];
        }else {
            [SVProgressHUD dismiss];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Bilgi" message:@"Lütfen geçerli bir yemeksepeti linki giriniz." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Tamam" style:UIAlertActionStyleCancel handler:nil];
            [controller addAction:okButton];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}
-(void)createTask{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *URLString = [NSString stringWithFormat:@"https://eu1.locationiq.com/v1/reverse.php?key=910f6637a2c804&lat=%f&lon=%f&format=json",location.coordinate.latitude,location.coordinate.longitude];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            //  NSLog(@"%@ %@" ,responseObject[@"address"][@"town"]);
            self->CountryName =  responseObject[@"address"][@"town"];
            [self setDatabase];
        }
    }];
    [dataTask resume];
}
-(void)setDatabase{
    [self performSegueWithIdentifier:@"tamamla" sender:nil];
//    self->referance = [[FIRDatabase database]reference];
//    NSDictionary *setValueDic = @{@"restorantName":self->placeName.text,
//                                  @"restorantYemekSepeti":self->yemekSepetiLink.text,
//                                  @"addtional":self->addtional.text,
//                                  @"region":countryName,
//                                  @"enlem":@(self->location.coordinate.latitude),
//                                  @"boylam":@(self->location.coordinate.longitude),
//                                  @"foodType":self->selectedFromPickerViewByFOOD[0],
//                                  @"foodType1":self->selectedFromPickerViewByFOOD[1],
//                                  @"foodType2":self->selectedFromPickerViewByFOOD[2],
//                                  @"senderID": [FIRAuth auth].currentUser.uid
//                                  };
//    [[[self->referance child:@"Restorants"]childByAutoId] setValue:setValueDic];
//    [SVProgressHUD dismiss];
//    //        AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    //        [appDel segueAfterSave];
//    UserRestorantsVC * hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"restorantSide"];
//    AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDel.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:hvc];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"tamamla"]){
        TamamlaVC *tamamla = (TamamlaVC *)[segue destinationViewController];
        CLLocation *LOC = [[CLLocation alloc]initWithLatitude:location.coordinate.latitude    longitude:location.coordinate.longitude];
        [tamamla setTakeCoordinate:LOC];
        [tamamla other:self->placeName.text restLink:self->yemekSepetiLink.text addtional:self->addtional.text];
        // gerçekte cihazda burayı aktif et
      //  [tamamla andCounryNanm:self->CountryName];
        [tamamla andCounryNanm:@"Şişli"];
        
    }
}
-(void)configMapview{
    mapView.delegate = self;
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    
    manager.desiredAccuracy = kCLLocationAccuracyBest; // en iyi lokasyon verisi
    [manager requestWhenInUseAuthorization];
    [manager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocationCoordinate2D location2d = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location2d,span);
    [self.mapView setRegion:region animated:YES];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    annotation.title = @"Seçilen lokasyon";
    [self.mapView addAnnotation:annotation];
}

- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
