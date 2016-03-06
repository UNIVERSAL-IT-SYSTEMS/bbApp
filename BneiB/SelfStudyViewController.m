//
//  SelfStudyViewController.m
//  KabNew
//
//  Created by Gabriel Morales on 1/31/16.
//  Copyright © 2016 Gabe Morales. All rights reserved.
//

#import "SelfStudyViewController.h"

@interface SelfStudyViewController ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic) NSArray *menuItems;

@end

@implementation SelfStudyViewController

- (instancetype)init {
    if ((self = [super init])) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.preferredContentSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGSizeMake(320.0, 600.0) : CGSizeMake(CGRectGetWidth(self.collection.bounds), CGRectGetHeight(self.collection.bounds) /3);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
