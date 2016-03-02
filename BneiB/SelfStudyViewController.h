//
//  SelfStudyViewController.h
//  KabNew
//
//  Created by Gabriel Morales on 1/31/16.
//  Copyright © 2016 Gabe Morales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfStudyViewController : UIViewController<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>

@property (nonatomic) UICollectionView *collection;

@end
