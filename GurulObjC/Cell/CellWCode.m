//
//  CellWCode.m
//  GurulObjC
//
//  Created by Mac on 21.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "CellWCode.h"

@implementation CellWCode

@synthesize RestName;
@synthesize RestExplain;
@synthesize view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        view = [[UIView alloc] initWithFrame:CGRectMake(5, 0,UIScreen.mainScreen.bounds.size.width - 10,80)];
        view.layer.cornerRadius = view.frame.size.width / 35.0;
        view.clipsToBounds = YES;
       RestName  = [[UILabel alloc]initWithFrame:CGRectMake(5, 5,UIScreen.mainScreen.bounds.size.width, 30)];
       RestExplain.textColor = [UIColor whiteColor];
       RestName.textColor = [UIColor whiteColor];
       RestExplain = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, UIScreen.mainScreen.bounds.size.width, 30)];
        RestName.textColor = [UIColor blackColor];
        RestExplain.textColor = [UIColor blackColor];
        [view addSubview:RestExplain];
        [view addSubview:RestName];
        [self.contentView addSubview:view];
        
    }
    return self;
}



@end
