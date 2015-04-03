//
//  PercentageCountingLabel.h
//
//  Created by Michael Shin on 3/27/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PercentageCountingLabel : UILabel

- (void)countFromZeroPercentToPercentage:(int)percentage withDuration:(NSTimeInterval)duration;

@end
