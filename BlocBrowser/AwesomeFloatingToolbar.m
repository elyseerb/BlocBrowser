//
//  UIView+AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Elyse Erb on 8/1/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray<UIButton*> *buttons;
@property (nonatomic, weak) UIButton *currentButton;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;


@end

@implementation AwesomeFloatingToolbar
NSInteger offset = 0;

- (instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
    
    if (self) {
        
        // Save the titles, and set the 4 colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray<UIButton*> *buttonsArray = [[NSMutableArray alloc] init];
        
        // Make the 4 buttons
        for (NSString *currentTitle in self.currentTitles) {
            UIButton *button = [[UIButton alloc] init];
            button.userInteractionEnabled = NO;
            button.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisButton = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisButton = [self.colors objectAtIndex:currentTitleIndex];
            
            //button.textAlignment = NSTextAlignmentCenter;
            //button.font = [UIFont systemFontOfSize:10];
            //button.text = titleForThisButton;
            [button setTitle:titleForThisButton forState:UIControlStateNormal];
            button.backgroundColor = colorForThisButton;
            button.tintColor = [UIColor whiteColor];
            
            [buttonsArray addObject:button];
        }
        
        self.buttons = buttonsArray;
        
        for (UIButton *thisButton in self.buttons) {
            [self addSubview:thisButton];
        }
    }
    
    // #1
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    // #2x
    [self addGestureRecognizer:self.tapGesture];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
    [self addGestureRecognizer:self.panGesture];
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self addGestureRecognizer:self.pinchGesture];
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:self.longPressGesture];
    return self;
    
}

- (void)rotateColors {
    offset++;
    
    // UIColor *colorForThisBgit@github.com:elyseerb/Blocstagram.gitutton = [self.colors objectAtIndex:currentTitleIndex];
    for (NSInteger labelNum = 0; labelNum < self.buttons.count; labelNum++) {
        self.buttons[labelNum].backgroundColor = [self.colors objectAtIndex:(labelNum+offset)%self.buttons.count];
    }
}

- (void) pinchDetected: (UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = recognizer.scale;
        
        NSLog(@"New scale: %f", scale);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToScale:)]) {
            [self.delegate floatingToolbar:self didTryToScale:scale];
        }
        [recognizer setScale:1.0];
    }
}


- (void) tapFired:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) { // #3
        CGPoint location = [recognizer locationInView:self]; // #4
        UIButton *tappedView = (UIButton *)[self hitTest:location withEvent:nil]; // #5
        
        if ([self.buttons containsObject:tappedView]) { // #6
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:(tappedView).currentTitle];
            }
        }
    }
}

- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
    
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (void) longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        if ([self.delegate respondsToSelector:@selector(floatingToolbarLongPressed:)]) {
            [self.delegate floatingToolbarLongPressed:self];
        }
    }
    
}

- (void) layoutSubviews {
    // set the frames for the 4 labels
    
    for (UIButton *thisButton in self.buttons) {
        NSUInteger currentLabelIndex = [self.buttons indexOfObject:thisButton];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        // adjust labelX and labelY for each label
        if (currentLabelIndex < 2) {
            // 0 or 1, so on top
            labelY = 0;
        } else {
            // 2 or 3, so on bottom
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentLabelIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
            // 0 or 2, so on the left
            labelX = 0;
        } else {
            // 1 or 3, so on the right
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisButton.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
}

#pragma mark - Touch Handling

- (UIButton *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    
    if ([subview isKindOfClass:[UIButton class]]) {
        return (UIButton *)subview;
    } else {
        return nil;
    }
}

#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UIButton *label = [self.buttons objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
    }
}


@end