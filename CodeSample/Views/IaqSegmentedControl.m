//
//  IaqSegmentedControl.m
//
//  Created by Michael Shin on 3/24/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "IaqSegmentedControl.h"
#import "DesignUtility.h"

@interface IaqSegmentedControl()

@end

@implementation IaqSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        [self setupView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    [self setTitle:NSLocalizedString(@"12 Months", nil) forSegmentAtIndex:0];
    [self setTitle:NSLocalizedString(@"30 Days", nil) forSegmentAtIndex:1];
    [self setTitle:NSLocalizedString(@"7 Days", nil) forSegmentAtIndex:2];
    [self setTitle:NSLocalizedString(@"24 Hours", nil) forSegmentAtIndex:3];
    
    [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  kDesignIaqSegmentedControlFont, NSFontAttributeName,
                                  nil] forState:UIControlStateNormal];
    
    [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor whiteColor], NSForegroundColorAttributeName,
                                  nil] forState:UIControlStateSelected];
    
    [self setBackgroundImage:[UIImage imageNamed:@"iaq_segmented_control_background"]
                    forState:UIControlStateNormal
                  barMetrics:UIBarMetricsDefault];
    
    [self setBackgroundImage:[UIImage imageNamed:@"iaq_segmented_control_selected"]
                    forState:UIControlStateSelected
                  barMetrics:UIBarMetricsDefault];
    
    [self setBackgroundImage:[UIImage imageNamed:@"iaq_segmented_control_selected"]
                    forState:UIControlStateHighlighted
                  barMetrics:UIBarMetricsDefault];
    
    [self setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateNormal
                      rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [self setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateSelected
                      rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [self setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateNormal
                      rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
}

@end
