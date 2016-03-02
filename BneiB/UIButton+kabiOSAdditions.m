//
//  UIButton+kabiOSAdditions.m
//  KabNew
//
//  Created by Rockstar. on 11/2/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import "UIButton+kabiOSAdditions.h"
#import "UIColor+kabIOSAdditions.h"
#import "UIFont+kabiOSAdditions.h"

@implementation UIButton (kabiOSAdditions)

+ (UIButton *)languageButton {
    UIButton *button = [[self alloc] initWithFrame:CGRectZero];
    [button setBackgroundImage:[[UIImage imageNamed:@"btn_standard_blue_border_default"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"btn_timeline_cta_rect_default"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor kabBlueColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor kabBlueColor] forState:UIControlStateHighlighted];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    button.titleLabel.font = [UIFont boldKabInterfaceFontOfSize:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 30.0 : 15.0];
    button.titleEdgeInsets = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0f);
    return button;
}

+ (UIButton *)viewButton {
    UIButton *button = [[self alloc] initWithFrame:CGRectZero];
    [button setBackgroundImage:[[UIImage imageNamed:@"btn_standard_blue_border_default"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"btn_standard_blue_border_pressed"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor kabDarkTextColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor kabDarkTextColor] forState:UIControlStateHighlighted];
    [button setTintColor:[UIColor whiteColor]];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    button.titleLabel.font = [UIFont boldKabInterfaceFontOfSize:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 30.0 : 15.0];
    button.titleEdgeInsets = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0f);

    return button;
}

@end
