//
//  CellWCode.h
//  GurulObjC
//
//  Created by Mac on 21.08.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellWCode : UITableViewCell{
    UILabel *RestName;
    UILabel *RestExplain;
    UIView  *view;
}
@property (nonatomic, retain) UILabel *RestName;
@property (nonatomic, retain) UILabel *RestExplain;
@property (nonatomic, retain) UIView *view;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
