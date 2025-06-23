//
//  ViewController.m
//  ObjC-6
//
//  Created by Anastasia on 22.06.2025.
//

#import "ViewController.h"
#import <Security/Security.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.todoItems = [NSMutableArray array];
    self.usernameField.delegate = self;
    self.todoField.delegate = self;
    
    // Настройка таблицы
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    // Загрузка данных
    [self loadUserData];
    [self loadTodoItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLastVisitDate];
}

#pragma mark - Data Storage Methods

- (void)saveUserData {
    [self.userDefaults setObject:self.usernameField.text forKey:@"username"];
    [self.userDefaults setObject:self.todoField.text forKey:@"todoText"];
    [self.userDefaults setObject:[NSDate date] forKey:@"lastVisit"];
    [self.userDefaults synchronize];
    
    [self saveToKeychain:self.usernameField.text forKey:@"username"];
    NSLog(@"Saving todoText: %@", self.todoField.text);
}

- (void)loadUserData {
    NSString *username = [self.userDefaults stringForKey:@"username"];
    NSString *todoText = [self.userDefaults stringForKey:@"todoText"];
    NSDate *lastVisit = [self.userDefaults objectForKey:@"lastVisit"];
    
    if (!username) {
        username = [self loadFromKeychain:@"username"];
    }

    self.usernameField.text = username;
    self.todoField.text = todoText;
    self.lastVisitLabel.text = [NSString stringWithFormat:@"Дата последнего визита: %@", [self formatDate:lastVisit]];
    NSLog(@"Loaded todoText: %@", todoText);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self updateLastVisitDate];
}

- (void)updateLastVisitDate {
    NSDate *now = [NSDate date];
    [self.userDefaults setObject:now forKey:@"lastVisit"];
    [self.userDefaults synchronize];
}

- (NSString *)formatDate:(NSDate *)date {
    if (!date) return @"Never";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    return [formatter stringFromDate:date];
}

#pragma mark - Todo Items Management

- (void)saveTodoItems {
    switch (self.storageSelector.selectedSegmentIndex) {
        case 0: // UserDefaults
            [self saveToUserDefaults];
            break;
        case 1: // PropertyList
            [self saveToPropertyList];
            break;
        case 2: // FileManager
            [self saveToFile];
            break;
        case 3: // YapDatabase (имитация)
            [self saveToYapDatabase];
            break;
    }
}

- (void)loadTodoItems {
    switch (self.storageSelector.selectedSegmentIndex) {
        case 0: // UserDefaults
            [self loadFromUserDefaults];
            break;
        case 1: // PropertyList
            [self loadFromPropertyList];
            break;
        case 2: // FileManager
            [self loadFromFile];
            break;
        case 3: // YapDatabase (имитация)
            [self loadFromYapDatabase];
            break;
    }
    [self.tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.usernameField || textField == self.todoField) {
        [self saveUserData];
    }
}

#pragma mark - Storage Implementations

// UserDefaults
- (void)saveToUserDefaults {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.todoItems];
    [self.userDefaults setObject:data forKey:@"todoItems"];
    [self.userDefaults synchronize];
}

- (void)loadFromUserDefaults {
    NSData *data = [self.userDefaults objectForKey:@"todoItems"];
    if (data) {
        self.todoItems = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

// PropertyList
- (void)saveToPropertyList {
    NSMutableArray *plistArray = [NSMutableArray array];
    for (TodoItem *item in self.todoItems) {
        [plistArray addObject:@{
            @"title": item.title,
            @"completed": @(item.completed),
            @"creationDate": item.creationDate
        }];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"todo.plist"];
    
    [plistArray writeToFile:path atomically:YES];
}

- (void)loadFromPropertyList {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"todo.plist"];
    
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:path];
    [self.todoItems removeAllObjects];
    
    for (NSDictionary *dict in plistArray) {
        TodoItem *item = [[TodoItem alloc] init];
        item.title = dict[@"title"];
        item.completed = [dict[@"completed"] boolValue];
        item.creationDate = dict[@"creationDate"];
        [self.todoItems addObject:item];
    }
}

// FileManager
- (void)saveToFile {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.todoItems];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"todo.dat"];
    
    [data writeToFile:filePath atomically:YES];
}

- (void)loadFromFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"todo.dat"];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        self.todoItems = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

// YapDatabase (упрощенная имитация)
- (void)saveToYapDatabase {
    // В реальном приложении здесь была бы работа с реальной YapDatabase
    // Для примера сохраним в файл с другим именем
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.todoItems];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"todo_yap.dat"];
    
    [data writeToFile:filePath atomically:YES];
}

- (void)loadFromYapDatabase {
    // В реальном приложении здесь была бы работа с реальной YapDatabase
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"todo_yap.dat"];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        self.todoItems = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

#pragma mark - Keychain Methods

- (void)saveToKeychain:(NSString *)value forKey:(NSString *)key {
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *query = @{
        (id)kSecClass: (id)kSecClassGenericPassword,
        (id)kSecAttrAccount: key,
        (id)kSecValueData: data,
        (id)kSecAttrAccessible: (id)kSecAttrAccessibleWhenUnlocked
    };
    
    SecItemDelete((CFDictionaryRef)query);
    SecItemAdd((CFDictionaryRef)query, NULL);
    NSLog(@"Saving username to keychain: %@", value);
}

- (NSString *)loadFromKeychain:(NSString *)key {
    NSDictionary *query = @{
        (id)kSecClass: (id)kSecClassGenericPassword,
        (id)kSecAttrAccount: key,
        (id)kSecReturnData: (id)kCFBooleanTrue,
        (id)kSecMatchLimit: (id)kSecMatchLimitOne
    };
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, &result);
    
    if (status == errSecSuccess) {
        NSData *data = (__bridge_transfer NSData *)result;
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    NSLog(@"Loaded from keychain: %@", result ? [[NSString alloc] initWithData:(__bridge NSData *)result encoding:NSUTF8StringEncoding] : @"nil");
    return nil;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodoCell" forIndexPath:indexPath];
    
    TodoItem *item = self.todoItems[indexPath.row];
    cell.textLabel.text = item.title;
    cell.accessoryType = item.completed ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TodoItem *item = self.todoItems[indexPath.row];
    item.completed = !item.completed;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self saveTodoItems];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.todoItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveTodoItems];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self saveUserData];
        [textField resignFirstResponder];
    } else if (textField == self.todoField) {
        [self addTodo:nil];
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)addTodo:(id)sender {
    if (self.todoField.text.length > 0) {
        TodoItem *item = [[TodoItem alloc] initWithTitle:self.todoField.text];
        [self.todoItems addObject:item];
        [self.tableView reloadData];
        [self saveTodoItems];

        [self saveUserData];
        
        self.todoField.text = @"";
        [self.todoField resignFirstResponder];
    }
}


- (IBAction)resetAllChecks:(id)sender {
    for (TodoItem *item in self.todoItems) {
        item.completed = NO;
    }
    [self.tableView reloadData];
    [self saveTodoItems];
}

- (IBAction)storageChanged:(id)sender {
    [self loadTodoItems];
}

@end
