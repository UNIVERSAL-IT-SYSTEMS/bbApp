//
//  LoginViewController.h
//  KabNew
//
//  Created by Rockstar. on 11/10/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, strong, readonly) UITextField *usernameTextField;
@property (nonatomic, strong, readonly) UITextField *nameTextField;
@property (nonatomic, strong, readonly) UITextField *lastNameTextField;
@property (nonatomic, strong, readonly) UITextField *emailTextField;
@property (nonatomic, strong, readonly) UITextField *passwordTextField;
@property (nonatomic, strong) UITableView *table;

+ (CGFloat)textFieldWidth;

- (void)signIn:(id)sender;
- (void)signUp:(id)sender;
- (void)forgot:(id)sender;

@end
