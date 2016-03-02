//
//  LoginViewController.m
//  KabNew
//
//  Created by Rockstar. on 11/10/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
- (void)_toggleMode:(id)sender;
- (void)_toggleModeAnimated:(BOOL)animated;
- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)_validateButton;
@end

@implementation LoginViewController{
    UIButton *_footerButton;
    BOOL _signUpMode;
}

@synthesize usernameTextField = _usernameTextField;
@synthesize nameTextField = _nameTextField;
@synthesize lastNameTextField = _lastNameTextField;
@synthesize emailTextField = _emailTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize table = _table;

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self class] textFieldWidth], 30.0f)];
        _nameTextField.keyboardType = UIKeyboardTypeDefault;
        _nameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _nameTextField.textColor = [UIColor kabBlueColor];
        _nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameTextField.delegate = self;
        _nameTextField.returnKeyType = UIReturnKeyNext;
        _nameTextField.font = [UIFont kabInterfaceFontOfSize:18.0f];
    }
    return _nameTextField;
}

- (UITextField *)lastNameTextField {
    if (!_lastNameTextField) {
        _lastNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self class] textFieldWidth], 30.0f)];
        _lastNameTextField.keyboardType = UIKeyboardTypeDefault;
        _lastNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _lastNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _lastNameTextField.textColor = [UIColor kabBlueColor];
        _lastNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _lastNameTextField.delegate = self;
        _lastNameTextField.returnKeyType = UIReturnKeyNext;
        _lastNameTextField.font = [UIFont kabInterfaceFontOfSize:18.0f];
    }
    return _lastNameTextField;
}

- (UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self class] textFieldWidth], 30.0f)];
        _usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _usernameTextField.textColor = [UIColor kabBlueColor];
        _usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _usernameTextField.delegate = self;
        _usernameTextField.returnKeyType = UIReturnKeyNext;
        _usernameTextField.font = [UIFont kabInterfaceFontOfSize:18.0f];
    }
    return _usernameTextField;
}


- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self class] textFieldWidth], 30.0f)];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.textColor = [UIColor kabBlueColor];
        _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordTextField.delegate = self;
        _passwordTextField.returnKeyType = UIReturnKeyGo;
        _passwordTextField.font = [UIFont kabInterfaceFontOfSize:18.0f];
    }
    return _passwordTextField;
}


- (UITextField *)emailTextField {
    if (!_emailTextField) {
        _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self class] textFieldWidth], 30.0f)];
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.textColor = [UIColor kabBlueColor];
        _emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _emailTextField.delegate = self;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.placeholder = @"Your email address";
        _emailTextField.font = [UIFont kabInterfaceFontOfSize:18.0f];
    }
    return _emailTextField;
}

#pragma mark - Class Methods
+ (CGFloat)textFieldWidth {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 360.0f : 180.0f;
}

#pragma mark - NSObject
- (instancetype)init {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        
    }
    return self;
}


#pragma mark - UITableView
- (void)loadTableView {
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 32.0f)];
    footer.backgroundColor = [UIColor clearColor];
    footer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = [UIColor blackColor];
    footer.font = [UIFont systemFontOfSize:14.0f];
    footer.text = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    footer.shadowColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    footer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.backgroundColor = [UIColor lightTextColor];
    _table.delegate = self;
    _table.dataSource = self;
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _table.scrollEnabled = YES;
    [_table reloadData];
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.separatorColor = [UIColor kabBlueColor];
    _table.tableFooterView = footer;
    [self.view addSubview:_table];
    
    NSDictionary *viewDict = @{@"table": _table};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|"
                                                                      options:kNilOptions metrics:nil
                                                                        views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|"
                                                                      options:kNilOptions metrics:nil
                                                                        views:viewDict]];
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *background = [[UIView alloc] initWithFrame:CGRectZero];
    background.backgroundColor = [UIColor kabStaticColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 34.0f)];
    [_footerButton setTitleColor:[UIColor kabBlueColor] forState:UIControlStateNormal];
    [_footerButton setTitleColor:[UIColor kabTextColor] forState:UIControlStateHighlighted];
    [_footerButton addTarget:self action:@selector(_toggleMode:) forControlEvents:UIControlEventTouchUpInside];
    _footerButton.titleLabel.font = [UIFont kabInterfaceFontOfSize:16.0f];
    self.tableView.tableFooterView = _footerButton;
    
    _signUpMode = NO;
    [self _toggleModeAnimated:NO];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self.navigationController setHidesBarsOnTap:YES];
//    [self.navigationController setHidesBarsWhenKeyboardAppears:YES];
    [self.navigationController setHidesBarsOnSwipe:YES];
    
    //    [self _checkUser];
    // TODO: Terrible hack
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.usernameTextField becomeFirstResponder];
    });
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - Actions

- (void)signIn:(id)sender {
    if (!self.navigationItem.rightBarButtonItem.enabled) {
        
        return;
    }
    
    NSString *username = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"Oops"
                                                           message:@"Make sure you enter your user name and password!"
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else {
        //        GMHudView *hud = [[GMHudView alloc] initWithTitle:@"Signing in..." loading:YES];
        //        [hud show];
        //        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        //            if (error) {
        //                UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Sorry!"
        //                                                                   message:[error.userInfo objectForKey:@"error"]
        //                                                                  delegate:nil
        //                                                         cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //
        //                [alertView show];
        //                [hud failAndDismissWithTitle:@"Failed"];
        //            }
        //
        //            else {
        //                [hud completeAndDismissWithTitle:@"Signed In!"];
        //                FeedViewController *viewController = [[FeedViewController alloc] init];
        //                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        //                //        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        //                navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //                [self.navigationController presentViewController:navController animated:YES completion:nil];
        //            }
        //        }];
        //    }
        
    }
}


- (void)signUp:(id)sender {
    if (!self.navigationItem.rightBarButtonItem.enabled) {
        return;
    }
    
    NSString *first = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *last = [_lastNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *username = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email    = [_emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                            message:@"Make sure you enter a correct username, password and email address!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    else if (first.length <= 3 || last.length <= 3 || username.length <=3) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                            message:@"Field is too short!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    else if (password.length <= 6) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                            message:@"Password does not meet the requirements!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    else if (email.length <= 5) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                            message:@"Please enter a valid email address"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else {
        //        GMHudView *hud = [[GMHudView alloc] initWithTitle:@"Signing up..." loading:YES];
        //        [hud show];
        
        //        PFUser *newUser = [PFUser user];
        //        newUser.username = username;
        //        newUser.password = password;
        //        newUser.email = email;
        
        //        newUser[@"first"] = first;
        //        newUser[@"last"] = last;
        
        //        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //            if (error) {
        //                [hud failAndDismissWithTitle:@"Failed"];
        //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
        //                                                                    message:[error.userInfo objectForKey:@"error"]
        //                                                                   delegate:nil
        //                                                          cancelButtonTitle:@"OK"
        //                                                          otherButtonTitles:nil, nil];
        //                [alertView show];
        //            }
        //            else {
        //                [hud completeAndDismissWithTitle:@"Signed Up!"];
        //                FeedViewController *viewController = [[FeedViewController alloc] init];
        //                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        //                //        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        //                navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //                [self.navigationController presentViewController:navController animated:YES completion:nil];
        //
        //            }
        //        }];
        //    }
    }
    
}


- (void)forgot:(id)sender {
    //	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.forgot.com"]];
}


#pragma mark - Private

- (void)_toggleMode:(id)sender {
    [self _toggleModeAnimated:YES];
}


- (void)_toggleModeAnimated:(BOOL)animated {
    NSArray *email = @[[NSIndexPath indexPathForRow:1 inSection:0]];
    NSArray *name = @[[NSIndexPath indexPathForRow:2 inSection:0]];
    NSArray *last = @[[NSIndexPath indexPathForRow:3 inSection:0]];
    
    BOOL focusPassword = [self.emailTextField isFirstResponder];
    UITableViewRowAnimation animation = animated ? UITableViewRowAnimationTop : UITableViewRowAnimationNone;
    
    // Switch to sign in
    if (_signUpMode) {
        _signUpMode = NO;
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:email withRowAnimation:animation];
        [self.tableView deleteRowsAtIndexPaths:name withRowAnimation:animation];
        [self.tableView deleteRowsAtIndexPaths:last withRowAnimation:animation];
        [self.tableView endUpdates];
        
        [_footerButton setTitle:@"Don't have an account? Sign Up →" forState:UIControlStateNormal];
        
        self.usernameTextField.placeholder = @"Username or email";
        self.passwordTextField.placeholder = @"Your password";
        
        if (focusPassword) {
            [self.passwordTextField becomeFirstResponder];
        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStylePlain target:self action:@selector(signIn:)];
    }
    
    // Switch to sign up
    else {
        _signUpMode = YES;
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:email withRowAnimation:animation];
        [self.tableView insertRowsAtIndexPaths:name withRowAnimation:animation];
        [self.tableView insertRowsAtIndexPaths:last withRowAnimation:animation];
        [self.tableView endUpdates];
        
        [_footerButton setTitle:@"Already have an account? Sign In →" forState:UIControlStateNormal];
        
        self.nameTextField.placeholder = @"Your first name";
        self.lastNameTextField.placeholder = @"Your last name";
        self.usernameTextField.placeholder = @"Choose a username";
        self.passwordTextField.placeholder = @"Choose a password";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStylePlain target:self action:@selector(signUp:)];
    }
    
    [self _validateButton];
}


- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Username";
        cell.accessoryView = self.usernameTextField;
        return;
    }
    
    if (_signUpMode) {
        if (indexPath.row == 1) {
            cell.textLabel.text = @"First name";
            cell.accessoryView = self.nameTextField;
            return;
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"Last name";
            cell.accessoryView = self.lastNameTextField;
            return;
        }
        else if (indexPath.row == 3) {
            cell.textLabel.text = @"Email";
            cell.accessoryView = self.emailTextField;
            return;
        }
    }
    
    cell.textLabel.text = @"Password";
    cell.accessoryView = self.passwordTextField;
}


- (void)_validateButton {
    BOOL valid = self.usernameTextField.text.length >= 3 && self.passwordTextField.text.length >= 6;
    
    if (_signUpMode && valid) {
        valid = self.emailTextField.text.length >= 5 && self.nameTextField.text.length != 0 && self.lastNameTextField.text.length != 0;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = valid;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _signUpMode ? 5 : 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor kabTextColor];
        cell.textLabel.font = [UIFont kabInterfaceFontOfSize:18.0f];
    }
    
    [self _configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Education Center";
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // TODO: Terrible hack #shipit
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _validateButton];
    });
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //User
    if (textField == self.usernameTextField) {
        if (_signUpMode) {
            [self.nameTextField becomeFirstResponder];
        } else {
            [self.passwordTextField becomeFirstResponder];
        }
    }
    //First Name
    else if (textField == self.nameTextField) {
        if (_signUpMode) {
            [self.lastNameTextField becomeFirstResponder];
        } else {
            [self.passwordTextField becomeFirstResponder];
        }
    }
    //Last Name
    else if (textField == self.lastNameTextField) {
        if (_signUpMode) {
            [self.emailTextField becomeFirstResponder];
        } else {
            [self.passwordTextField becomeFirstResponder];
        }
    }
    //Email
    else if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    //Password
    else if (textField == self.passwordTextField) {
        if (_signUpMode) {
            [self signUp:textField];
        } else {
            [self signIn:textField];
        }
    }
    [textField resignFirstResponder];
    
    return YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self _checkUser];
    }
}


#pragma mark - Private

- (void)_checkUser {
    //    PFUser *currentUser = [PFUser currentUser];
    //    if (currentUser) {
    //        UIViewController *viewController = [[FeedViewController alloc] init];
    //        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    //        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    //
    //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //            [self.splitViewController presentViewController:navigationController animated:YES completion:nil];
    //        } else {
    //            
    //            [self.navigationController presentViewController:navigationController animated:NO completion:nil];
    //            NSLog(@"Current user: %@", currentUser.username);
    //        }
    //        
    //        return;
    //    }
}

@end
