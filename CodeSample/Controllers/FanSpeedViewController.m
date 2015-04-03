//
//  FanSpeedViewController.m
//  
//
//  Created by Michael Shin on 2/19/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "FanSpeedViewController.h"
#import "DataManager.h"
#import "Purifier.h"
#import "FanSpeedControl.h"
#import "DesignUtility.h"

#define kTimeDelayBeforeDismissingViewController 0.4
#define kFanSpeedButtonPaddingToArc 26.0
#define kFanSpeedButtonImageLabelPaddingToButton 34.0
#define kFanSpeedButtonLabelPaddingToButtonX 38.0
#define kFanSpeedButtonLabelPaddingToButtonY 28.0
#define kFanSpeedButtonWidthHeight 50.0
#define kFanSpeedButtonLabelWidthHeight 58.0
#define kButtonLabelFontSize 21.0
#define kSmartModeButtonWidthHeight 50.0

@interface FanSpeedViewController ()

@property (weak, nonatomic) IBOutlet FanSpeedControl *fanSpeedControl;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (strong, nonatomic) UIButton *sleepButton;
@property (strong, nonatomic) UIButton *speedOneButton;
@property (strong, nonatomic) UIButton *speedTwoButton;
@property (strong, nonatomic) UIButton *speedThreeButton;
@property (strong, nonatomic) UIButton *turboButton;

@property (strong, nonatomic) UILabel *sleepButtonLabel;
@property (strong, nonatomic) UIImageView *speedOneButtonLabel;
@property (strong, nonatomic) UIImageView *speedTwoButtonLabel;
@property (strong, nonatomic) UIImageView *speedThreeButtonLabel;
@property (strong, nonatomic) UILabel *turboButtonLabel;

@property (strong, nonatomic) UIButton *smartModeButton;
@property (strong, nonatomic) UILabel *smartModeButtonLabel;

- (IBAction)closeButtonAction:(id)sender;

@end

@implementation FanSpeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purifierStatusDidChange) name:kDataManagerPurifierStateChanged object:nil];
    
    self.navigationBar.topItem.title = self.purifier.Name;
    [DesignUtility setBackgroundForView:self.view];
    
    [self.fanSpeedControl addTarget:self action:@selector(fanSpeedDidChange) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLayoutSubviews
{
    [self.fanSpeedControl setNeedsLayout];
    [self.fanSpeedControl layoutIfNeeded];
    
    [self addFanSpeedButtons];
    //[self purifierStatusDidChange];
}

- (void)addFanSpeedButtons
{
    // Labels for fan speed buttons
    CGRect buttonLabelFrame = CGRectMake(0, 0, kFanSpeedButtonLabelWidthHeight, kFanSpeedButtonLabelWidthHeight);
    self.sleepButtonLabel = [[UILabel alloc] initWithFrame:buttonLabelFrame];
    self.speedOneButtonLabel = [[UIImageView alloc] initWithFrame:buttonLabelFrame];
    self.speedTwoButtonLabel = [[UIImageView alloc] initWithFrame:buttonLabelFrame];
    self.speedThreeButtonLabel = [[UIImageView alloc] initWithFrame:buttonLabelFrame];
    self.turboButtonLabel = [[UILabel alloc] initWithFrame:buttonLabelFrame];
    
    self.sleepButtonLabel.text = NSLocalizedString(@"Sleep", nil);
    self.sleepButtonLabel.textColor = kDesignDefaultBlue;
    self.sleepButtonLabel.textAlignment = NSTextAlignmentCenter;
    self.sleepButtonLabel.font = kDesignFanSpeedButtonFont;
    
    self.speedOneButtonLabel.image = [UIImage imageNamed:@"fan_level1"];
    self.speedOneButtonLabel.contentMode = UIViewContentModeCenter;
    
    self.speedTwoButtonLabel.image = [UIImage imageNamed:@"fan_level2"];
    self.speedTwoButtonLabel.contentMode = UIViewContentModeCenter;
    
    self.speedThreeButtonLabel.image = [UIImage imageNamed:@"fan_level3"];
    self.speedThreeButtonLabel.contentMode = UIViewContentModeCenter;
    
    self.turboButtonLabel.text = NSLocalizedString(@"Turbo", nil);
    self.turboButtonLabel.textColor = kDesignDefaultBlue;
    self.turboButtonLabel.textAlignment = NSTextAlignmentCenter;
    self.turboButtonLabel.font = kDesignFanSpeedButtonFont;
    
    self.sleepButtonLabel.center = [self buttonLabelCenterForFanSpeed:PurifierStateFanSpeedSleep];
    self.speedOneButtonLabel.center = [self buttonLabelCenterForFanSpeed:PurifierStateFanSpeed1];
    self.speedTwoButtonLabel.center = [self buttonLabelCenterForFanSpeed:PurifierStateFanSpeed2];
    self.speedThreeButtonLabel.center = [self buttonLabelCenterForFanSpeed:PurifierStateFanSpeed3];
    self.turboButtonLabel.center = [self buttonLabelCenterForFanSpeed:PurifierStateFanSpeedTurbo];
    
    [self.view addSubview:self.sleepButtonLabel];
    [self.view addSubview:self.speedOneButtonLabel];
    [self.view addSubview:self.speedTwoButtonLabel];
    [self.view addSubview:self.speedThreeButtonLabel];
    [self.view addSubview:self.turboButtonLabel];
    
    // Fan speed buttons
    CGRect buttonFrame = CGRectMake(0, 0, kFanSpeedButtonWidthHeight, kFanSpeedButtonWidthHeight);
    self.sleepButton = [[UIButton alloc] initWithFrame:buttonFrame];
    self.speedOneButton = [[UIButton alloc] initWithFrame:buttonFrame];
    self.speedTwoButton = [[UIButton alloc] initWithFrame:buttonFrame];
    self.speedThreeButton = [[UIButton alloc] initWithFrame:buttonFrame];
    self.turboButton = [[UIButton alloc] initWithFrame:buttonFrame];
    
    [self.sleepButton setImage:[UIImage imageNamed:@"sleep_off"] forState:UIControlStateNormal];
    [self.sleepButton setImage:[UIImage imageNamed:@"sleep_on"] forState:UIControlStateSelected];
    [self.speedOneButton setImage:[UIImage imageNamed:@"level1_off"] forState:UIControlStateNormal];
    [self.speedOneButton setImage:[UIImage imageNamed:@"level1_on"] forState:UIControlStateSelected];
    [self.speedTwoButton setImage:[UIImage imageNamed:@"level2_off"] forState:UIControlStateNormal];
    [self.speedTwoButton setImage:[UIImage imageNamed:@"level2_on"] forState:UIControlStateSelected];
    [self.speedThreeButton setImage:[UIImage imageNamed:@"level3_off"] forState:UIControlStateNormal];
    [self.speedThreeButton setImage:[UIImage imageNamed:@"level3_on"] forState:UIControlStateSelected];
    [self.turboButton setImage:[UIImage imageNamed:@"turbo_off"] forState:UIControlStateNormal];
    [self.turboButton setImage:[UIImage imageNamed:@"turbo_on"] forState:UIControlStateSelected];
    
    self.sleepButton.center = [self buttonCenterForFanSpeed:PurifierStateFanSpeedSleep];
    self.speedOneButton.center = [self buttonCenterForFanSpeed:PurifierStateFanSpeed1];
    self.speedTwoButton.center = [self buttonCenterForFanSpeed:PurifierStateFanSpeed2];
    self.speedThreeButton.center = [self buttonCenterForFanSpeed:PurifierStateFanSpeed3];
    self.turboButton.center = [self buttonCenterForFanSpeed:PurifierStateFanSpeedTurbo];
    
    [self.view addSubview:self.sleepButton];
    [self.view addSubview:self.speedOneButton];
    [self.view addSubview:self.speedTwoButton];
    [self.view addSubview:self.speedThreeButton];
    [self.view addSubview:self.turboButton];
    
    // Smart mode button
    self.smartModeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSmartModeButtonWidthHeight, kSmartModeButtonWidthHeight)];
    [self.smartModeButton setImage:[UIImage imageNamed:@"smart_off"] forState:UIControlStateNormal];
    [self.smartModeButton setImage:[UIImage imageNamed:@"smart_on"] forState:UIControlStateSelected];
    //[self.smartModeButton addTarget:self action:@selector(smartModeButtonAction:) forControlEvents:UIControlEventTouchDown];
    self.smartModeButton.center = CGPointMake(self.fanSpeedControl.arcCenter.x - self.fanSpeedControl.radius * 0.35 - self.fanSpeedControl.frame.origin.x,
                                              self.fanSpeedControl.arcCenter.y - self.fanSpeedControl.radius * 0.35 + self.fanSpeedControl.frame.origin.y);
    [self.view addSubview:self.smartModeButton];
    
    self.smartModeButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kFanSpeedButtonLabelWidthHeight, kFanSpeedButtonLabelWidthHeight)];
    self.smartModeButtonLabel.text = NSLocalizedString(@"Smart", nil);
    self.smartModeButtonLabel.textColor = kDesignDefaultBlue;
    self.smartModeButtonLabel.textAlignment = NSTextAlignmentCenter;
    self.smartModeButtonLabel.font = kDesignFanSpeedButtonFont;
    self.smartModeButtonLabel.center = CGPointMake(self.smartModeButton.center.x, self.smartModeButton.center.y + self.smartModeButton.frame.size.height * 0.55);
    [self.view addSubview:self.smartModeButtonLabel];
}

- (void)fanSpeedDidChange
{
    self.sleepButton.selected = NO;
    self.speedOneButton.selected = NO;
    self.speedTwoButton.selected = NO;
    self.speedThreeButton.selected = NO;
    self.turboButton.selected = NO;
    
    self.sleepButtonLabel.textColor = kDesignDefaultBlue;
    self.speedOneButtonLabel.image = [UIImage imageNamed:@"fan_level1"];
    self.speedTwoButtonLabel.image = [UIImage imageNamed:@"fan_level2"];
    self.speedThreeButtonLabel.image = [UIImage imageNamed:@"fan_level3"];
    self.turboButtonLabel.textColor = kDesignDefaultBlue;
    
    switch (_fanSpeedControl.fanSpeed) {
        case PurifierStateFanSpeedSleep:
            self.sleepButton.selected = YES;
            self.sleepButtonLabel.textColor = [UIColor whiteColor];
            break;
            
        case PurifierStateFanSpeed1:
            self.speedOneButton.selected = YES;
            self.speedOneButtonLabel.image = [UIImage imageNamed:@"fan_level1_on"];
            break;
            
        case PurifierStateFanSpeed2:
            self.speedTwoButton.selected = YES;
            self.speedTwoButtonLabel.image = [UIImage imageNamed:@"fan_level2_on"];
            break;
            
        case PurifierStateFanSpeed3:
            self.speedThreeButton.selected = YES;
            self.speedThreeButtonLabel.image = [UIImage imageNamed:@"fan_level3_on"];
            break;
            
        case PurifierStateFanSpeedTurbo:
            self.turboButton.selected = YES;
            self.turboButtonLabel.textColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
}
/*

- (void)purifierStatusDidChange
{
    PurifierState *state = [[DataManager sharedInstance] getPurifierStateForChannel:self.purifier.Channel];
    [self.fanSpeedControl setPurifierState:state];
    self.smartModeButton.selected = state.smartMode;
    self.smartModeButtonLabel.textColor = state.smartMode ? [UIColor whiteColor] : kDesignDefaultBlue;
    
    self.sleepButton.selected = NO;
    self.speedOneButton.selected = NO;
    self.speedTwoButton.selected = NO;
    self.speedThreeButton.selected = NO;
    self.turboButton.selected = NO;
    
    self.sleepButtonLabel.textColor = kDesignDefaultBlue;
    self.speedOneButtonLabel.image = [UIImage imageNamed:@"fan_level1"];
    self.speedTwoButtonLabel.image = [UIImage imageNamed:@"fan_level2"];
    self.speedThreeButtonLabel.image = [UIImage imageNamed:@"fan_level3"];
    self.turboButtonLabel.textColor = kDesignDefaultBlue;
    
    switch (state.fanSpeed) {
        case PurifierStateFanSpeedSleep:
            self.sleepButton.selected = YES;
            self.sleepButtonLabel.textColor = [UIColor whiteColor];
            break;
            
        case PurifierStateFanSpeed1:
            self.speedOneButton.selected = YES;
            self.speedOneButtonLabel.image = [UIImage imageNamed:@"fan_level1_on"];
            break;
            
        case PurifierStateFanSpeed2:
            self.speedTwoButton.selected = YES;
            self.speedTwoButtonLabel.image = [UIImage imageNamed:@"fan_level2_on"];
            break;
            
        case PurifierStateFanSpeed3:
            self.speedThreeButton.selected = YES;
            self.speedThreeButtonLabel.image = [UIImage imageNamed:@"fan_level3_on"];
            break;
            
        case PurifierStateFanSpeedTurbo:
            self.turboButton.selected = YES;
            self.turboButtonLabel.textColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
}

- (void)changeAndPubishFanSpeed:(PurifierStateFanSpeed)fanSpeed
{
    PurifierState *state = [[DataManager sharedInstance] getPurifierStateForChannel:self.purifier.Channel];
    state.fanSpeed = fanSpeed;
    state.smartMode = NO;
    [[DataManager sharedInstance] publishPurifierState:state];
    
    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:kTimeDelayBeforeDismissingViewController];
}

- (void)fanSpeedDidChange
{
    [self changeAndPubishFanSpeed:_fanSpeedControl.fanSpeed];
}

- (void)sleepButtonAction:(id)sender
{
    [self changeAndPubishFanSpeed:PurifierStateFanSpeedSleep];
}

- (void)speedOneButtonAction:(id)sender
{
    [self changeAndPubishFanSpeed:PurifierStateFanSpeed1];
}

- (void)speedTwoButtonAction:(id)sender
{
    [self changeAndPubishFanSpeed:PurifierStateFanSpeed2];
}

- (void)speedThreeButtonAction:(id)sender
{
    [self changeAndPubishFanSpeed:PurifierStateFanSpeed3];
}

- (void)turboButtonAction:(id)sender
{
    [self changeAndPubishFanSpeed:PurifierStateFanSpeedTurbo];
}

- (void)smartModeButtonAction:(id)sender
{
    PurifierState *state = [[DataManager sharedInstance] getPurifierStateForChannel:self.purifier.Channel];
    state.smartMode = !state.smartMode;
    [[DataManager sharedInstance] publishPurifierState:state];
    //[[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerPurifierStateChanged object:nil];
    
    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:kTimeDelayBeforeDismissingViewController];
}

- (IBAction)closeButtonAction:(id)sender
{
    [self dismissViewController];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/
- (CGPoint)buttonCenterForFanSpeed:(PurifierStateFanSpeed)fanSpeed
{
    float angle = M_PI_2 * fanSpeed/kFanSpeedControlNumberOfSegments;
    
    float xDistanceFromCenter = (self.fanSpeedControl.radius + kFanSpeedButtonPaddingToArc + 0.5 * kFanSpeedControlArcWidth) * cosf(angle);
    float yDistanceFromCenter = (self.fanSpeedControl.radius + kFanSpeedButtonPaddingToArc + 0.5 * kFanSpeedControlArcWidth) * sinf(angle);
    
    float x = self.fanSpeedControl.arcCenter.x - self.fanSpeedControl.frame.origin.x - xDistanceFromCenter;
    float y = self.fanSpeedControl.arcCenter.y + self.fanSpeedControl.frame.origin.y - yDistanceFromCenter;
    
    return CGPointMake(x, y);
}

- (CGPoint)buttonLabelCenterForFanSpeed:(PurifierStateFanSpeed)fanSpeed
{
    CGPoint labelCenter = [self buttonCenterForFanSpeed:fanSpeed];
    
    float angle = M_PI_2 * fanSpeed/kFanSpeedControlNumberOfSegments;
    
    if(fanSpeed == PurifierStateFanSpeedSleep || fanSpeed == PurifierStateFanSpeedTurbo) {
        labelCenter.x -= kFanSpeedButtonLabelPaddingToButtonX * cosf(angle);
        labelCenter.y -= kFanSpeedButtonLabelPaddingToButtonY * sinf(angle);
    }
    else {
        labelCenter.x -= kFanSpeedButtonImageLabelPaddingToButton * cosf(angle);
        labelCenter.y -= kFanSpeedButtonImageLabelPaddingToButton * sinf(angle);
    }
    
    return labelCenter;
}

@end
