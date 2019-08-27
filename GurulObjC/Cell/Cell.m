//
//  Cell.m
//  GurulObjC
//
//  Created by Mac on 17.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "Cell.h"

@implementation Cell
@synthesize RestName;
@synthesize RestExplain;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
