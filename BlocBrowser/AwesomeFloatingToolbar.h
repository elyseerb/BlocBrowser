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

@end

@interface AwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

@property (nonatomic, weak) id <AwesomeFloatingToolbarDelegate> delegate;
@property(nonatomic, readonly) UIGestureRecognizerState state;
@property(nonatomic) CFTimeInterval minimumPressDuration;
@property(nonatomic) NSUInteger numberOfTouchesRequired;
@property(nonatomic) NSUInteger numberOfTapsRequired;
@property(nonatomic) CGFloat allowableMovement;

@end
