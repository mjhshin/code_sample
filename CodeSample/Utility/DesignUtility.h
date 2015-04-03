//
//  Design.h
//  
//
//  Created by Michael Shin on 3/5/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#define UIFontBoldRobotoWithSize(fontSize)      [UIFont fontWithName:@"Avenir-Heavy" size:fontSize]
#define UIFontMediumRobotoWithSize(fontSize)    [UIFont fontWithName:@"Avenir-Medium" size:fontSize]
#define UIFontRegularRobotoWithSize(fontSize)   [UIFont fontWithName:@"Avenir-Medium" size:fontSize]
#define UIFontLightRobotoWithSize(fontSize)     [UIFont fontWithName:@"Avenir-Light" size:fontSize]

#pragma mark - Color

#define kDesignDefaultBlue                         UIColorFromHex(0x489FFF)
#define kDesignDefaultRed                          UIColorFromHex(0xFF5400)
#define kDesignTabBarItemTitleColor                UIColorFromHex(0x57B1FF)
#define kDesignFanSpeedCircleButtonColor           UIColorFromHex(0x48CAFF)
#define kDesignControlGradientStartColor           UIColorFromHex(0x3CECA4)
#define kDesignControlGradientEndColor             UIColorFromHex(0x008EFF)
#define kDesignUnfilledArcColor                    UIColorFromHex(0x18252C)

#define kDesignGoodGradientStartColor              UIColorFromHex(0x008EFF)
#define kDesignGoodGradientEndColor                UIColorFromHex(0x3CECA4)
#define kDesignModerateGradientStartColor          UIColorFromHex(0x00C8AA)
#define kDesignModerateGradientEndColor            UIColorFromHex(0xCCFF00)
#define kDesignUnhealthyGradientStartColor         UIColorFromHex(0xFF4135)
#define kDesignUnhealthyGradientEndColor           UIColorFromHex(0xFFE63C)
#define kDesignVeryUnhealthyGradientStartColor     UIColorFromHex(0xFF4C05)
#define kDesignVeryUnhealthyGradientEndColor       UIColorFromHex(0xDA4AFF)

#pragma mark - Fonts

#define kDesignNavigationBarFont           UIFontMediumRobotoWithSize(25)
#define kDesignTabBarItemFont              UIFontMediumRobotoWithSize(17)
#define kDesignBarButtonItemFont           UIFontRegularRobotoWithSize(20)
#define kDesignSegmentedControlFont        UIFontRegularRobotoWithSize(18)

#define kDesignFanSpeedCircleButtonFont    UIFontMediumRobotoWithSize(20)
#define kDesignFanSpeedButtonFont          UIFontMediumRobotoWithSize(21)

#define kDesignTimerCountdownFont          UIFontLightRobotoWithSize(40)
#define kDesignTimerButtonLargeFont        UIFontMediumRobotoWithSize(40)
#define kDesignTimerButtonSmallFont        UIFontMediumRobotoWithSize(25)

#define kDesignScheduleRowTimeFont         UIFontMediumRobotoWithSize(22)
#define kDesignScheduleRowAMPMFont         UIFontRegularRobotoWithSize(15)
#define kDesignScheduleRowWeekdayFont      UIFontRegularRobotoWithSize(15)

#define kDesignEditScheduleTimeFont        UIFontRegularRobotoWithSize(14)
#define kDesignEditScheduleAMPMFont        UIFontRegularRobotoWithSize(15)
#define kDesignEditScheduleWeekdayFont     UIFontRegularRobotoWithSize(15)

#define kDesignFilterTypeFont              UIFontMediumRobotoWithSize(21)
#define kDesignFilterPercentageFont        UIFontBoldRobotoWithSize(21)
#define kDesignFilterActionButtonFont      UIFontRegularRobotoWithSize(15)

#define kDesignIaqSegmentedControlFont     UIFontRegularRobotoWithSize(15)
#define kDesignIaqTitleFont                UIFontRegularRobotoWithSize(25)
#define kDesignIaqLegendFont               UIFontRegularRobotoWithSize(14)
#define kDesignIaqPercentageFont           UIFontRegularRobotoWithSize(12)
#define kDesignIaqTimeFont                 UIFontRegularRobotoWithSize(12)
#define kDesignIaqCurrentTimeFont          UIFontMediumRobotoWithSize(14)

#define kDesignSettingsFont                UIFontRegularRobotoWithSize(20)

#define kDesignButtonFont                  UIFontMediumRobotoWithSize(23)

@interface DesignUtility : NSObject

+ (void)setGlobalAppearance;
+ (void)setBackgroundForView:(UIView *)view;
+ (CGGradientRef)controlArcGradientRef;
+ (CGGradientRef)gradientRefForIaq:(int)iaq;

@end
