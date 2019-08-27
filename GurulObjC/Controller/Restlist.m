//
//  Restlist.m
//  GurulObjC
//
//  Created by Mac on 7.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "Restlist.h"
#import "CellWCode.h"
@import Firebase;

@interface Restlist ()

@end

@implementation Restlist
@synthesize tableView;
@synthesize arrayRestName;
@synthesize arrayRestURL;
@synthesize arrayNameExplain;
@synthesize referance;


- (void)viewDidLoad {
    [super viewDidLoad];
    self->arrayRestURL = [[NSMutableArray alloc]init];
    self->arrayRestName = [[NSMutableArray alloc]init];
    self->arrayNameExplain = [[NSMutableArray alloc]init];
    [self->tableView registerClass:[CellWCode class] forCellReuseIdentifier:@"cell"];
    tableView.backgroundColor = [UIColor clearColor];
   // tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //  [self->tableView registerNib:[UINib  nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self->tableView.delegate = self;
    self->tableView.dataSource = self;
    [self setArrayRestName:self->arrayRestName];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self->arrayRestName.count == 0){
        return 0;
    }else {
        return self->arrayRestName.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self->arrayRestName.count == 0){
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = @"Yakınlarda bir restoran bulamadık.";
        cell.layer.cornerRadius = cell.frame.size.width / 40.0;
        [cell setUserInteractionEnabled:NO];
        return cell;
    }else {
        CellWCode *customCell = [[CellWCode alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:@"cell"];
        if (customCell != nil){
            if(self->arrayRestName.count > 0){
                customCell.RestName.text = self->arrayRestName[indexPath.row];

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSURL* url = [[NSURL alloc] initWithString: self->arrayRestURL[indexPath.row]];
    [[UIApplication sharedApplication] openURL: url];
}
- (void)setArrayRestName:(NSMutableArray *)arrayRestName{
    self->referance = [[FIRDatabase database]reference];
    [[self->referance child:@"Restorants"]observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // normalde burada latitude ve long göre şehir gelecek eğer eşleşirse gelecek veriler
        [self->arrayRestName addObject:snapshot.value[@"restorantName"]];// ekleneme
        [self->arrayNameExplain addObject:snapshot.value[@"addtional"]];
        [self->arrayRestURL addObject:snapshot.value[@"restorantYemekSepeti"]];
        [self->tableView reloadData];
    }];
}
@end
