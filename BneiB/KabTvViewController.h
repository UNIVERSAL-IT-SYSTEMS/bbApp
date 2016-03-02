//
//  KabTvViewController.h
//  KabNew
//
//  Created by Rockstar. on 10/31/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KabTvViewController : UIViewController<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *collection;


//- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;

//- (void)playEnglish:(id)sender;
//- (void)playHebrew:(id)sender;
//- (void)playRussian:(id)sender;
//- (void)playSpanish:(id)sender;
//- (void)viewSchedule:(id)sender;
//- (void)openActionScheed:(id)sender;

@end
