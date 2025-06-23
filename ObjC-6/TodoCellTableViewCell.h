//
//  TodoCellTableViewCell.h
//  ObjC-6
//
//  Created by Anastasia on 22.06.2025.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodoCellTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *checkmarkImageView;
@property (strong, nonatomic) UIButton *deleteButton;

- (void)configureWithTitle:(NSString *)title isCompleted:(BOOL)completed;

@end

NS_ASSUME_NONNULL_END
