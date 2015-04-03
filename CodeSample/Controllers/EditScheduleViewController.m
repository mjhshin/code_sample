//
//  AddScheduleViewController.m
//  
//
//  Created by Michael Shin on 2/24/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "EditScheduleViewController.h"
#import "EditScheduleControl.h"
//#import "Schedule.h"
#import "DataManager.h"
#import "DesignUtility.h"

#define kDayInSeconds 86400.0

@interface EditScheduleViewController ()

@property (weak, nonatomic) IBOutlet EditScheduleControl *scheduleControl;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *mondayButton;
@property (weak, nonatomic) IBOutlet UIButton *tuesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *wednesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *thursdayButton;
@property (weak, nonatomic) IBOutlet UIButton *fridayButton;
@property (weak, nonatomic) IBOutlet UIButton *saturdayButton;
@property (weak, nonatomic) IBOutlet UIButton *sundayButton;

@end

@implementation EditScheduleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [DesignUtility setBackgroundForView:self.view];
    
    [_scheduleControl addTarget:self action:@selector(updateTimeLabel) forControlEvents:UIControlEventValueChanged];
    
    if(_schedule) {
        self.navigationItem.title = NSLocalizedString(@"Edit Schedule", nil);
        /*
        _scheduleControl.startValue = [self dateToPercentage:_schedule.StartTime];
        _scheduleControl.endValue = [self dateToPercentage:_schedule.EndTime];
        [_scheduleControl setNeedsDisplay];
        
        int weekdays = [_schedule.Weekdays intValue];
        _mondayButton.selected      = (weekdays & ScheduleWeekdayMonday);
        _tuesdayButton.selected     = (weekdays & ScheduleWeekdayTuesday);
        _wednesdayButton.selected   = (weekdays & ScheduleWeekdayWednesday);
        _thursdayButton.selected    = (weekdays & ScheduleWeekdayThursday);
        _fridayButton.selected      = (weekdays & ScheduleWeekdayFriday);
        _saturdayButton.selected    = (weekdays & ScheduleWeekdaySaturday);
        _sundayButton.selected      = (weekdays & ScheduleWeekdaySunday);
         */
    }
    else {
        self.navigationItem.title = NSLocalizedString(@"Add Schedule", nil);
    }
    
    [self updateTimeLabel];
}

- (void)updateTimeLabel
{
    NSString *startTime = [self percentageToDateString:_scheduleControl.startValue];
    NSString *endTime = [self percentageToDateString:_scheduleControl.endValue];
    
    _timeLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
}

- (NSString *)percentageToDateString:(float)percentageTime
{
    BOOL isPM = percentageTime >= 0.5;
    
    float rawTime = percentageTime * 24;
    int hours = floorf(rawTime);
    int minutes = fmodf(rawTime, 1) * 60;
    minutes -= fmodf(minutes, 30);
    
    if(isPM)
        hours -= 12;
    
    if(hours == 0)
        hours = 12;
    
    return [NSString stringWithFormat:@"%i:%02d %@", hours, minutes, isPM ? @"PM" : @"AM"];
}

- (float)dateToPercentage:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute
                                               fromDate:date];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    
    return (hours + minutes / 60.0) / 24.0;
}
/*
- (IBAction)saveButtonAction:(UIButton *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    NSDate *startDate = [formatter dateFromString: [self percentageToDateString:_scheduleControl.startValue]];
    NSDate *endDate = [formatter dateFromString: [self percentageToDateString:_scheduleControl.endValue]];
    
    // TODO: Handle this better
    if(_scheduleControl.endValue < _scheduleControl.startValue) {
        endDate = [endDate dateByAddingTimeInterval:kDayInSeconds];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSDateComponents *endComponents = [calendar components:NSCalendarUnitDay fromDate:endDate];
        
        if(endComponents.day > 2) {
            startDate = [startDate dateByAddingTimeInterval:-kDayInSeconds];
            endDate = [endDate dateByAddingTimeInterval:-kDayInSeconds];
        }
    }
    
    int weekdays = 0;
    if(self.mondayButton.selected)
        weekdays |= ScheduleWeekdayMonday;
    if(self.tuesdayButton.selected)
        weekdays |= ScheduleWeekdayTuesday;
    if(self.wednesdayButton.selected)
        weekdays |= ScheduleWeekdayWednesday;
    if(self.thursdayButton.selected)
        weekdays |= ScheduleWeekdayThursday;
    if(self.fridayButton.selected)
        weekdays |= ScheduleWeekdayFriday;
    if(self.saturdayButton.selected)
        weekdays |= ScheduleWeekdaySaturday;
    if(self.sundayButton.selected)
        weekdays |= ScheduleWeekdaySunday;
    
    // Must select at least one day
    if(weekdays == 0) {
        return;
    }
    
    sender.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(_schedule) {
        // Use copy so changes don't reflect in ScheduleViewController if save failed.
        Schedule *editedSchedule = [_schedule copy];
        editedSchedule.StartTime = startDate;
        editedSchedule.EndTime = endDate;
        editedSchedule.Weekdays = [NSNumber numberWithInt:weekdays];
        
        [editedSchedule saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded) {
                _schedule.StartTime = editedSchedule.StartTime;
                _schedule.EndTime = editedSchedule.EndTime;
                _schedule.Weekdays = editedSchedule.Weekdays;
                
                [self.delegate scheduleChanged:_schedule newSchedule:NO];
                [self dismissViewController];
            }
            sender.enabled = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else {
        Schedule *schedule = [[Schedule alloc] initForPurifier:_purifier startDate:startDate endDate:endDate weekdays:weekdays];
        
        [[DataManager sharedInstance] addSchedule:schedule withBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded) {
                [self.delegate scheduleChanged:schedule newSchedule:YES];
                [self dismissViewController];
            }
            sender.enabled = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self dismissViewController];
}

- (IBAction)weekdayButtonAction:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/
@end
