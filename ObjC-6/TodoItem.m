//
//  TodoItem.m
//  ObjC-6
//
//  Created by Anastasia on 22.06.2025.
//

#import "TodoItem.h"

@implementation TodoItem

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = title;
        _completed = NO;
        _creationDate = [NSDate date];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeBool:self.completed forKey:@"completed"];
    [coder encodeObject:self.creationDate forKey:@"creationDate"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _title = [coder decodeObjectForKey:@"title"];
        _completed = [coder decodeBoolForKey:@"completed"];
        _creationDate = [coder decodeObjectForKey:@"creationDate"];
    }
    return self;
}


@end
