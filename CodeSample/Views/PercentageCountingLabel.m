//
//  PercentageCountingLabel.m
//
//  Created by Michael Shin on 3/27/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "PercentageCountingLabel.h"
#import "DesignUtility.h"

@interface PercentageCountingLabel()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int currentPercentage;
@property (nonatomic, assign) int destinationPercentage;
@property (nonatomic, assign) NSTimeInterval countDuration;
@end

@implementation PercentageCountingLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        [self setupView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setupView];
}

- (void)setupView
{
    self.text = @"0%";
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor whiteColor];
    self.shadowColor = [UIColor darkTextColor];
    self.shadowOffset = CGSizeMake(0.5, 0.5);
    self.font = kDesignIaqPercentageFont;
    self.layer.zPosition = FLT_MAX;
    self.currentPercentage = 0;
}

- (void)countFromZeroPercentToPercentage:(int)percentage withDuration:(NSTimeInterval)duration
{
    [self reset];
    
    _destinationPercentage = percentage;
    _countDuration = duration;
    _timer = [NSTimer scheduledTimerWithTimeInterval:duration/100.0
                                              target:self
                                            selector:@selector(updateText)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)updateText
{
    self.text = [NSString stringWithFormat:@"%i%%", _currentPercentage];
    
    if(_currentPercentage >= _destinationPercentage) {
        if(_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    else {
        _currentPercentage++;
    }
}

- (void)reset
{
    if(_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _currentPercentage = 0;
    _countDuration = 0.0;
    
    self.text = @"0%";
}

@end
