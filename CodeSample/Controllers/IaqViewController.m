//
//  IAQViewController.m
//  
//
//  Created by Michael Shin on 2/23/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "IaqViewController.h"
#import "Purifier.h"
#import "DesignUtility.h"
#import "IaqSegmentedControl.h"
#import "IaqBarGraphView.h"
#import "IaqLineGraphView.h"

#define ARC4RANDOM_MAX 0x100000000

@interface IaqViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet IaqBarGraphView *barGraphView;
@property (weak, nonatomic) IBOutlet IaqLineGraphView *lineGraphView;

- (IBAction)iaqSegmentedControlAction:(id)sender;

@end

@implementation IaqViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.purifier.Name;
    
    [DesignUtility setBackgroundForView:self.view];
    
    self.titleLabel.font = kDesignIaqTitleFont;
    self.titleLabel.text = NSLocalizedString(@"Indoor Air Quality", nil);
    self.titleLabel.textColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSNumber numberWithFloat:0.9]];
    [values addObject:[NSNumber numberWithFloat:0.6]];
    [values addObject:[NSNumber numberWithFloat:0.2]];
    [values addObject:[NSNumber numberWithFloat:0.1]];
    
    self.barGraphView.graphData = values;
    
    [self setLineGraphFakeData];
}

- (void)setLineGraphFakeData
{
    NSMutableArray *rawData = [NSMutableArray array];
    
    for (int i = 0; i < kIaqLineGraphViewNumDataPoints; i++) {
        [rawData addObject:[NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX)]]; // random number between 0 and 1
    }
    
    self.lineGraphView.graphData = [NSArray arrayWithArray:rawData];
}

- (IBAction)iaqSegmentedControlAction:(IaqSegmentedControl *)segmentedControl
{
    switch (segmentedControl.selectedSegmentIndex) {
        case 0: {
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSNumber numberWithFloat:0.9]];
            [values addObject:[NSNumber numberWithFloat:0.6]];
            [values addObject:[NSNumber numberWithFloat:0.2]];
            [values addObject:[NSNumber numberWithFloat:0.1]];
            
            self.barGraphView.graphData = values;
        }
            break;
            
        case 1: {
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSNumber numberWithFloat:1.0]];
            [values addObject:[NSNumber numberWithFloat:1.0]];
            [values addObject:[NSNumber numberWithFloat:0.0]];
            [values addObject:[NSNumber numberWithFloat:0.0]];
            
            self.barGraphView.graphData = values;
        }
            break;
            
        case 2: {
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSNumber numberWithFloat:0.0]];
            [values addObject:[NSNumber numberWithFloat:0.0]];
            [values addObject:[NSNumber numberWithFloat:1.0]];
            [values addObject:[NSNumber numberWithFloat:1.0]];
            
            self.barGraphView.graphData = values;
        }
            break;
            
        case 3: {
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSNumber numberWithFloat:0.985]];
            [values addObject:[NSNumber numberWithFloat:0.985]];
            [values addObject:[NSNumber numberWithFloat:0.985]];
            [values addObject:[NSNumber numberWithFloat:0.985]];
            
            self.barGraphView.graphData = values;
        }
            break;
            
        default:
            break;
    }
    
    [self setLineGraphFakeData];
}

@end
