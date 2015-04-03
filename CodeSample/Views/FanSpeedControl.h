//
//  FanSpeedControl.h
//  
//
//  Created by Michael Shin on 2/10/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Purifier.h"

#define kFanSpeedControlNumberOfSegments 4.0
#define kFanSpeedControlArcWidth 14.0

@interface FanSpeedControl : UIControl

@property (nonatomic, assign) PurifierStateFanSpeed fanSpeed;
@property (nonatomic, assign) CGPoint arcCenter;
@property (nonatomic, assign) CGFloat radius;

//- (void)setPurifierState:(PurifierState *)state;

@end
