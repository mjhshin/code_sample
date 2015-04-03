//
//  DesignUtility.m
//  
//
//  Created by Michael Shin on 3/5/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "DesignUtility.h"
//#import "TimerViewController.h"

@implementation DesignUtility

+ (void)setBackgroundForView:(UIView *)view
{
    UIImageView *imageView = [DesignUtility backgroundImage];
    imageView.frame = view.frame;
    [view insertSubview:imageView atIndex:0];
}

+ (UIImageView *)backgroundImage
{
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    background.contentMode = UIViewContentModeScaleToFill;
    
    return background;
}

+ (void)setGlobalAppearance
{
    [[UITabBarItem appearance]  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        kDesignTabBarItemTitleColor, NSForegroundColorAttributeName,
                                                        kDesignTabBarItemFont, NSFontAttributeName,
                                                        nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance]  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                                        nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -13.0)];
    
    [[UINavigationBar appearance] setTintColor:kDesignDefaultBlue];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          kDesignNavigationBarFont, NSFontAttributeName,
                                                          nil]];
    
    [[UIBarButtonItem appearance] setTintColor:kDesignDefaultBlue];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          kDesignBarButtonItemFont, NSFontAttributeName,
                                                          nil] forState:UIControlStateNormal];
    /*
    [[UISegmentedControl appearance] setTintColor:kDesignDefaultBlue];
    [[UISegmentedControl appearanceWhenContainedIn:[TimerViewController class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             kDesignDefaultBlue, NSForegroundColorAttributeName,
                             kDesignSegmentedControlFont, NSFontAttributeName,
                             nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearanceWhenContainedIn:[TimerViewController class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIColor whiteColor], NSForegroundColorAttributeName,
                             nil] forState:UIControlStateSelected];
    */
    [[UISwitch appearance] setOnTintColor:kDesignDefaultBlue];
    [[UISwitch appearance] setTintColor:[UIColor clearColor]];
    
    [[UIPageControl appearance] setTintColor:kDesignDefaultBlue];
}

+ (CGGradientRef)controlArcGradientRef
{
    return [DesignUtility gradientRefWithStartColor:kDesignControlGradientStartColor
                                    endColor:kDesignControlGradientEndColor];
}

+ (CGGradientRef)gradientRefForIaq:(int)iaq
{
    switch(iaq)
    {
        case 0:
            return [DesignUtility gradientRefWithStartColor:kDesignGoodGradientStartColor
                                                 endColor:kDesignGoodGradientEndColor];
            
        case 1:
            return [DesignUtility gradientRefWithStartColor:kDesignModerateGradientStartColor
                                                 endColor:kDesignModerateGradientEndColor];
            
        case 2:
            return [DesignUtility gradientRefWithStartColor:kDesignUnhealthyGradientStartColor
                                                 endColor:kDesignUnhealthyGradientEndColor];
            
        case 3:
            return [DesignUtility gradientRefWithStartColor:kDesignVeryUnhealthyGradientStartColor
                                                 endColor:kDesignVeryUnhealthyGradientEndColor];
            
        default:
            return nil;
    }
}

+ (CGGradientRef)gradientRefWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    
    CGFloat locations[2] = {0.0, 1.0}; // aka linear gradient
    
    const CGFloat *startComponents = CGColorGetComponents(startColor.CGColor);
    const CGFloat *endComponents = CGColorGetComponents(endColor.CGColor);
    
    CGFloat components[8] = {
        startComponents[0], startComponents[1], startComponents[2], startComponents[3],
        endComponents[0], endComponents[1], endComponents[2], endComponents[3]
    };
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, num_locations);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}


@end
