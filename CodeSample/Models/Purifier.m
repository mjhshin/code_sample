//
//  Purifier.m
//  
//
//  Created by Michael Shin on 2/20/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "Purifier.h"
//#import <Parse/PFObject+Subclass.h>
//#import "Schedule.h"

@implementation Purifier

@dynamic Name;
@dynamic Channel;
@dynamic SleepTimerDuration;
@dynamic SleepTimerEndDate;

@synthesize sectionHeaderViewExpanded;

- (id)copyWithZone:(NSZone *)zone
{
    Purifier *copy = [[Purifier alloc] init];
    
    if(copy) {
        //copy.objectId = [self.objectId copyWithZone:zone];
        copy.Name = [self.Name copyWithZone:zone];
        copy.Channel = [self.Channel copyWithZone:zone];
        copy.SleepTimerDuration = [self.SleepTimerDuration copyWithZone:zone];
        copy.SleepTimerEndDate = [self.SleepTimerEndDate copyWithZone:zone];
        copy.sectionHeaderViewExpanded = self.sectionHeaderViewExpanded;
    }
    
    return copy;
}
/*
- (void)addSchedule:(Schedule *)schedule
{
    PFRelation *relation = [self relationForKey:@"Schedules"];
    [relation addObject:schedule];
}

- (void)removeSchedule:(Schedule *)schedule
{
    PFRelation *relation = [self relationForKey:@"Schedules"];
    [relation removeObject:schedule];
}

- (BOOL)sleepTimerEnabled
{
    if(self.SleepTimerDuration && self.SleepTimerEndDate) {
        return [self.SleepTimerEndDate timeIntervalSinceNow] > 0;
    }
    else {
        return NO;
    }
    
}

- (void)setSleepTimer:(int)hours withBlock:(PFBooleanResultBlock)block
{
    self.SleepTimerDuration = [NSNumber numberWithInt:hours];
    NSTimeInterval sleepTimerDurationInSeconds = 3600.0 * hours;
    self.SleepTimerEndDate = [[NSDate date] dateByAddingTimeInterval:sleepTimerDurationInSeconds];
    
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}

- (void)cancelSleepTimerWithBlock:(PFBooleanResultBlock)block
{
    self.SleepTimerEndDate = nil;
    self.SleepTimerDuration = nil;
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}
*/
+ (void)load
{
    //[self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Purifier";
}

@end
