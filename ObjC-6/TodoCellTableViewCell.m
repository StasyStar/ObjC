//
//  TodoCellTableViewCell.m
//  ObjC-6
//
//  Created by Anastasia on 22.06.2025.
//

#import "TodoCellTableViewCell.h"

@implementation TodoCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupViews];
    [self setupConstraints];
}

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    // Title Label
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    // Checkmark Image View
    _checkmarkImageView = [[UIImageView alloc] init];
    _checkmarkImageView.tintColor = [UIColor systemGreenColor];
    _checkmarkImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_checkmarkImageView];
    
    // Delete Button
    _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_deleteButton setImage:[UIImage systemImageNamed:@"trash"] forState:UIControlStateNormal];
    _deleteButton.tintColor = [UIColor systemRedColor];
    [self.contentView addSubview:_deleteButton];
}

- (void)setupConstraints {
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _checkmarkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // Title Label
        [_titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [_titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [_titleLabel.trailingAnchor constraintEqualToAnchor:_checkmarkImageView.leadingAnchor constant:-16],
        
        // Checkmark Image
        [_checkmarkImageView.trailingAnchor constraintEqualToAnchor:_deleteButton.leadingAnchor constant:-16],
        [_checkmarkImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [_checkmarkImageView.widthAnchor constraintEqualToConstant:24],
        [_checkmarkImageView.heightAnchor constraintEqualToConstant:24],
        
        // Delete Button
        [_deleteButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [_deleteButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [_deleteButton.widthAnchor constraintEqualToConstant:24],
        [_deleteButton.heightAnchor constraintEqualToConstant:24],
        
        // Content View
        [self.contentView.heightAnchor constraintGreaterThanOrEqualToConstant:60]
    ]];
}

- (void)configureWithTitle:(NSString *)title isCompleted:(BOOL)completed {
    _titleLabel.text = title;
    
    if (completed) {
        _checkmarkImageView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
        _titleLabel.textColor = [UIColor lightGrayColor];
        NSDictionary *attributes = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)};
        _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    } else {
        _checkmarkImageView.image = [UIImage systemImageNamed:@"circle"];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    UIView *selectionView = [[UIView alloc] init];
    selectionView.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.1];
    self.selectedBackgroundView = selectionView;
}

@end
