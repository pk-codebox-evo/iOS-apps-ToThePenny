//
//  SelectedCategoryCell.h
//  Depoza
//
//  Created by Ivan Magda on 19.04.15.
//  Copyright (c) 2015 Ivan Magda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedCategoryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *categoryNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;

@end
