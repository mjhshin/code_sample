//
//  AddScheduleViewController.h
//  
//
//  Created by Michael Shin on 2/24/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class Purifier;
@class Schedule;

@protocol EditScheduleViewControllerDelegate;

@interface EditScheduleViewController : UIViewController

@property (nonatomic, strong) Purifier *purifier;
@property (nonatomic, strong) Schedule *schedule;
@property (nonatomic, weak) id <EditScheduleViewControllerDelegate> delegate;

@end

#pragma mark - EditScheduleViewControllerDelegate

@protocol EditScheduleViewControllerDelegate <NSObject>

- (void)scheduleChanged:(Schedule *)schedule newSchedule:(BOOL)newSchedule;

@end
