//
//  ViewController.h
//  ObjC-6
//
//  Created by Anastasia on 22.06.2025.
//

#import <UIKit/UIKit.h>
#import "TodoItem.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UILabel *lastVisitLabel;
@property (weak, nonatomic) IBOutlet UITextField *todoField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *storageSelector;

@property (strong, nonatomic) NSMutableArray<TodoItem *> *todoItems;
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) NSString *filePath;

- (IBAction)addTodo:(id)sender;
- (IBAction)resetAllChecks:(id)sender;
- (IBAction)storageChanged:(id)sender;

@end

