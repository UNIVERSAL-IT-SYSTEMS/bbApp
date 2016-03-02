//
//  MediaCollectionViewController.h
//  KabNew
//
//  Created by Gabriel Morales on 12/20/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCollectionViewController : UIViewController<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *collection;

@end
