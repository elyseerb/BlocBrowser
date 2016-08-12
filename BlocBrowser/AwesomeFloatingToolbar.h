//
//  UIView+AwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Elyse Erb on 8/1/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AwesomeFloatingToolbar;

@protocol AwesomeFloatingToolbarDelegate <NSObject>

@optional

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;
- (void) floatingToolbarLongPressed:(AwesomeFloatingToolbar *)toolbar;

@end

@interface AwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;
-(void) rotateColors;

@property (nonatomic, weak) id <AwesomeFloatingToolbarDelegate> delegate;

@end
