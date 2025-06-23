//
//  TodoItem.h
//  ObjC-6
//
//  Created by Anastasia on 22.06.2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodoItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL completed;
@property (strong, nonatomic) NSDate *creationDate;

- (instancetype)initWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
