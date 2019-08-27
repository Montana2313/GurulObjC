//
//  AfterShake.m
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "AfterShake.h"
#import "CellWCode.h"
@import Firebase;
@import AFNetworking;

@interface AfterShake ()

@end

@implementation AfterShake
@synthesize arrayNames;
@synthesize arrayURLs;
@synthesize referance;
@synthesize arrayNameExplain;
@synthesize manager;



- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager requestWhenInUseAuthorization];
    [manager startUpdatingLocation];
  
    self->tablewView.delegate = self;
    self->tablewView.dataSource = self;
     [self->tablewView registerClass:[CellWCode class] forCellReuseIdentifier:@"cell"];
    tablewView.backgroundColor = [UIColor clearColor];
    //self->tablewView.separatorStyle = UITableViewCellEditingStyleNone;
    self->arrayNames = [[NSMutableArray alloc]init];
    self->arrayURLs  = [[NSMutableArray alloc ]init];
    self->arrayNameExplain  = [[NSMutableArray alloc ]init];
    NSLog(@"%@", self->ChoosenFoodType);
    self->ChoosenTExt.text = self->ChoosenFoodType;
    
}
-(void)createTask:(double)enlem boylam:(double)boylam{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *URLString = [NSString stringWithFormat:@"https://eu1.locationiq.com/v1/reverse.php?key=910f6637a2c804&lat=%f&lon=%f&format=json",enlem,boylam];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
          //  NSLog(@"%@ %@" ,responseObject[@"address"][@"town"]);
            NSString *CountryName =  responseObject[@"address"][@"town"];
            [self setArrayNames:self->arrayNames countryName:CountryName];
        }
    }];
    [dataTask resume];
}
//MARK : - TableView Process
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self->arrayNames.count == 0){
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = @"Yakınlarda bir restoran bulamadık.";
        cell.layer.cornerRadius = cell.frame.size.width / 40.0;
        self->tablewView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [cell setUserInteractionEnabled:NO];
        return cell;
    }else {
        CellWCode *customCell = [[CellWCode alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:@"cell"];
        self->tablewView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (customCell != nil){
            if(self->arrayNames.count > 0){
                customCell.RestName.text = self->arrayNames[indexPath.row];
             
                customCell.RestExplain.text = self->arrayNameExplain[indexPath.row];
                customCell.layer.cornerRadius = customCell.frame.size.width / 40.0;
                customCell.clipsToBounds = YES;
                customCell.RestExplain.textColor = [UIColor whiteColor];
                customCell.RestName.textColor = [UIColor whiteColor];
                
                customCell.backgroundColor = [UIColor clearColor];
            }
        }
        return customCell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self->arrayNames.count == 0){
        return 1;
    }else {
        return self->arrayNames.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSURL* url = [[NSURL alloc] initWithString: self->arrayURLs[indexPath.row]];
    [[UIApplication sharedApplication] openURL: url];
    [self->tablewView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)setChoosenType:(NSString *)type{
    self->ChoosenFoodType = type;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
     CLLocationCoordinate2D location = CLLocationCoordinate2DMake(locations[0].coordinate.latitude, locations[0].coordinate.longitude);
    if(enlem == 0.0 && boylam == 0.0){
        self->enlem = location.latitude;
        self->boylam = location.longitude;
        [self createTask:(double)location.latitude boylam:(double)location.longitude];
    }
}
-(void)setArrayNames:(NSMutableArray *)arrayNames countryName:(NSString*)cName{
    self->referance = [[FIRDatabase database]reference];
    [[self->referance child:@"Restorants"]observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot.value[@"region"] isEqualToString:@"Şişli"]){ //cName]){
            // normalde burada latitude ve long göre şehir gelecek eğer eşleşirse gelecek veriler -> cName e geliyor
            // veriler daha önce eklendiği için foodType 1 2 kontrolü yapıyor.
            // eğer silinirse foodTYPEarray üzerinden yapılması yeterli.
            NSMutableArray *array = [[NSMutableArray alloc] init];
            array = snapshot.value[@"foodTYPEarray"];
            if([snapshot.value[@"foodType"] isEqualToString:self->ChoosenFoodType] || [snapshot.value[@"foodType1"] isEqualToString:self->ChoosenFoodType] || [snapshot.value[@"foodType2"] isEqualToString:self->ChoosenFoodType] ||
                [array containsObject:self->ChoosenFoodType] == YES
               ){
                [arrayNames addObject:snapshot.value[@"restorantName"]];// ekleneme
                [self->arrayNameExplain addObject:snapshot.value[@"addtional"]];
                [self->arrayURLs addObject:snapshot.value[@"restorantYemekSepeti"]];
                [self->tablewView reloadData];
            }
            // BURADA ŞEHİR İSMİ VE FOOD TYPE A GÖRE VERİLER GELCEEK
         
        }
    }];
    
}
-(void)getStateWithLatAndLong{
    
}

@end
