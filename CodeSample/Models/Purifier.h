//
//  Purifier.h
//  
//
//  Created by Michael Shin on 2/20/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Parse/Parse.h>

@class Schedule;

#define kPurifierSleepTimerDurationOneHour      1
#define kPurifierSleepTimerDurationTwoHours     2
#define kPurifierSleepTimerDurationFourHours    4
#define kPurifierSleepTimerDurationEightHours   8

typedef enum {
    PurifierStateFanSpeedSleep = 0,
    PurifierStateFanSpeed1 = 1,
    PurifierStateFanSpeed2 = 2,
    PurifierStateFanSpeed3 = 3,
    PurifierStateFanSpeedTurbo = 4
} PurifierStateFanSpeed;

typedef enum {
    PurifierStateDustSensitivityHigh = 0,
    PurifierStateDustSensitivityMedium = 1,
    PurifierStateDustSensitivityLow = 2
} PurifierStateDustSensitivity;

typedef enum {
    PurifierStateIaqLevel1 = 0,
    PurifierStateIaqLevel2 = 1,
    PurifierStateIaqLevel3 = 2,
    PurifierStateIaqLevel4 = 3
} PurifierStateIaq;

//@interface Purifier : PFObject<PFSubclassing, NSCopying>
@interface Purifier : NSObject

+ (NSString *)parseClassName;

// Parse
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Channel;
@property (nonatomic, strong) NSNumber *SleepTimerDuration;
@property (nonatomic, strong) NSDate *SleepTimerEndDate;

// Non-Parse
@property (nonatomic, assign) BOOL sectionHeaderViewExpanded;

- (void)addSchedule:(Schedule *)schedule;
- (void)removeSchedule:(Schedule *)schedule;

- (BOOL)sleepTimerEnabled;

//- (void)setSleepTimer:(int)hours withBlock:(PFBooleanResultBlock)block;
//- (void)cancelSleepTimerWithBlock:(PFBooleanResultBlock)block;

@end
