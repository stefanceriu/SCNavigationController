//
//  SCMainViewController.m
//  SCPageViewController
//
//  Created by Stefan Ceriu on 15/02/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import "SCMainViewController.h"

typedef NS_ENUM(NSUInteger, SCPickerViewComponentType)
{
    SCPickerViewComponentTypeLayouter,
    SCPickerViewComponentTypeEasingFunction,
    SCPickerViewComponentTypeAnimationDuration
};

@interface SCMainViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *pageNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *visiblePercentageLabel;

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@end

@implementation SCMainViewController

#pragma mark - Public

- (void)setVisiblePercentage:(CGFloat)percentage
{
	[self.visiblePercentageLabel setText:[NSString stringWithFormat:@"%.3f%%", percentage]];
}

#pragma mark - Actions

- (IBAction)onPushButtonTap:(id)sender
{
    if([self.delegate respondsToSelector:@selector(mainViewControllerDidRequestPush:)]) {
        [self.delegate mainViewControllerDidRequestPush:self];
    }
}

- (IBAction)onPopButtonTap:(id)sender
{
    if([self.delegate respondsToSelector:@selector(mainViewControllerDidRequestPop:)]) {
        [self.delegate mainViewControllerDidRequestPop:self];
    }
}

- (IBAction)onPopToRootButtonTap:(id)sender
{
    if([self.delegate respondsToSelector:@selector(mainViewControllerDidRequestPopToRoot:)]) {
        [self.delegate mainViewControllerDidRequestPopToRoot:self];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return SCPickerViewComponentTypeAnimationDuration + 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch ((SCPickerViewComponentType)component) {
        case SCPickerViewComponentTypeLayouter:
            return SCStackLayouterTypeCount;
        case SCPickerViewComponentTypeEasingFunction:
            return SCEasingFunctionTypeBounceEaseInOut + 1;
        case SCPickerViewComponentTypeAnimationDuration:
            return 40;
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UIFont *font = [UIFont fontWithName:@"Menlo" size:18.0f];
    UIColor *color = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    switch ((SCPickerViewComponentType)component) {
        case SCPickerViewComponentTypeLayouter: {
            static NSDictionary *typeToString;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                typeToString = (@{@(SCStackLayouterTypePlain)              : @"Plain",
                                  @(SCStackLayouterTypeSliding)            : @"Sliding",
                                  @(SCStackLayouterTypeParallax)           : @"Parallax"});
            });
            
            return [[NSAttributedString alloc] initWithString:typeToString[@(row)]
                                                   attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName : color}];
        }
        case SCPickerViewComponentTypeEasingFunction:
        {
            static NSDictionary *typeToString;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                typeToString = (@{
                                  @(SCEasingFunctionTypeLinear)               : @"Linear",
                                  
                                  @(SCEasingFunctionTypeQuadraticEaseIn)      : @"Quadratic Ease In",
                                  @(SCEasingFunctionTypeQuadraticEaseOut)     : @"Quadratic Ease Out",
                                  @(SCEasingFunctionTypeQuadraticEaseInOut)   : @"Quadratic Ease In Out",
                                  
                                  @(SCEasingFunctionTypeCubicEaseIn)          : @"Cubic Ease In",
                                  @(SCEasingFunctionTypeCubicEaseOut)         : @"Cubic Ease Out",
                                  @(SCEasingFunctionTypeCubicEaseInOut)       : @"Cubic Ease In Out",
                                  
                                  @(SCEasingFunctionTypeQuarticEaseIn)        : @"Quartic Ease In",
                                  @(SCEasingFunctionTypeQuarticEaseOut)       : @"Quartic Ease Out",
                                  @(SCEasingFunctionTypeQuarticEaseInOut)     : @"Quartic Ease In Out",
                                  
                                  @(SCEasingFunctionTypeQuinticEaseIn)        : @"Quintic Ease In",
                                  @(SCEasingFunctionTypeQuinticEaseOut)       : @"Quintic Ease Out",
                                  @(SCEasingFunctionTypeQuinticEaseInOut)     : @"Quintic Ease In Out",
                                  
                                  @(SCEasingFunctionTypeSineEaseIn)           : @"Sine Ease In",
                                  @(SCEasingFunctionTypeSineEaseOut)          : @"Sine Ease Out",
                                  @(SCEasingFunctionTypeSineEaseInOut)        : @"Sine Ease In Out",
                                  
                                  @(SCEasingFunctionTypeCircularEaseIn)       : @"Circular Ease In",
                                  @(SCEasingFunctionTypeCircularEaseOut)      : @"Circular Ease Out",
                                  @(SCEasingFunctionTypeCircularEaseInOut)    : @"Circular Ease In Out",
                                  
                                  @(SCEasingFunctionTypeExponentialEaseIn)    : @"Exponential Ease In",
                                  @(SCEasingFunctionTypeExponentialEaseOut)   : @"Exponential Ease Out",
                                  @(SCEasingFunctionTypeExponentialEaseInOut) : @"Exponential Ease In Out",
                                  
                                  @(SCEasingFunctionTypeElasticEaseIn)        : @"Elastic Ease In",
                                  @(SCEasingFunctionTypeElasticEaseOut)       : @"Elastic Ease Out",
                                  @(SCEasingFunctionTypeElasticEaseInOut)     : @"Elastic Ease In Out",
                                  
                                  @(SCEasingFunctionTypeBackEaseIn)           : @"Back Ease In",
                                  @(SCEasingFunctionTypeBackEaseOut)          : @"Back Ease Out",
                                  @(SCEasingFunctionTypeBackEaseInOut)        : @"Back Ease In Out",
                                  
                                  @(SCEasingFunctionTypeBounceEaseIn)         : @"Bounce Ease In",
                                  @(SCEasingFunctionTypeBounceEaseOut)        : @"Bounce Ease Out",
                                  @(SCEasingFunctionTypeBounceEaseInOut)      : @"Bounce Ease In Out"
                                  });
            });
            
            return [[NSAttributedString alloc] initWithString:typeToString[@(row)]
                                                   attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName : color}];
        }
        case SCPickerViewComponentTypeAnimationDuration:
        {
            return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", [self _rowToDuration:row]]
                                                   attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName : color}];
        }
    }
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch ((SCPickerViewComponentType)component) {
        case SCPickerViewComponentTypeLayouter:
        {
            if([self.delegate respondsToSelector:@selector(mainViewControllerDidChangeLayouterType:)]) {
                [self.delegate mainViewControllerDidChangeLayouterType:self];
            }
            break;
        }
        case SCPickerViewComponentTypeEasingFunction:
        {
            self.easingFunctionType = (SCEasingFunctionType)row;
            
            if([self.delegate respondsToSelector:@selector(mainViewControllerDidChangeAnimationType:)]) {
                [self.delegate mainViewControllerDidChangeAnimationType:self];
            }
            break;
        }
        case SCPickerViewComponentTypeAnimationDuration:
        {
            self.duration = [self _rowToDuration:row];
            
            if([self.delegate respondsToSelector:@selector(mainViewControllerDidChangeAnimationDuration:)]) {
                [self.delegate mainViewControllerDidChangeAnimationDuration:self];
            }
            break;
        }
    }
}

- (NSTimeInterval)_rowToDuration:(NSUInteger)row
{
    return 0.25f * (row + 1);
}

- (NSUInteger)_durationToRow:(NSTimeInterval)duration
{
    return duration/0.25f - 1;
}

#pragma mark - Setters

- (SCStackLayouterType)layouterType
{
    return (SCStackLayouterType)[self.pickerView selectedRowInComponent:SCPickerViewComponentTypeLayouter];
}

- (void)setLayouterType:(SCStackLayouterType)layouterType
{
    [self.pickerView selectRow:layouterType inComponent:SCPickerViewComponentTypeLayouter animated:NO];
}

- (SCEasingFunctionType)easingFunctionType
{
    return (SCEasingFunctionType)[self.pickerView selectedRowInComponent:SCPickerViewComponentTypeEasingFunction];
}

- (void)setEasingFunctionType:(SCEasingFunctionType)easingFunctionType
{
    [self.pickerView selectRow:easingFunctionType inComponent:SCPickerViewComponentTypeEasingFunction animated:NO];
}

- (NSTimeInterval)duration
{
    return [self _rowToDuration:[self.pickerView selectedRowInComponent:SCPickerViewComponentTypeAnimationDuration]];
}

- (void)setDuration:(NSTimeInterval)duration
{
    [self.pickerView selectRow:[self _durationToRow:duration] inComponent:SCPickerViewComponentTypeAnimationDuration animated:NO];
}

@end
