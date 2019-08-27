//
//  Cell.h
//  GurulObjC
//
//  Created by Mac on 17.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *RestName;
@property (weak, nonatomic) IBOutlet UILabel *RestExplain;

@end

NS_ASSUME_NONNULL_END
