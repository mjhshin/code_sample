//
//  IndoorAirQualityBarGraphView.m
//  
//
//  Created by Michael Shin on 3/24/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "IaqBarGraphView.h"
#import "DesignUtility.h"
//#import "PurifierState.h"
#import "PercentageCountingLabel.h"

#define kArcWidth 16.0
#define kArcAnimationDuration 0.65
#define kPercentageAnimationDuration 0.65

@interface IaqBarGraphView()

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) PercentageCountingLabel *level1PercentageLabel;
@property (nonatomic, strong) PercentageCountingLabel *level2PercentageLabel;
@property (nonatomic, strong) PercentageCountingLabel *level3PercentageLabel;
@property (nonatomic, strong) PercentageCountingLabel *level4PercentageLabel;

@property (nonatomic, strong) NSMutableArray *sublayersArray;

@end

@implementation IaqBarGraphView

@synthesize graphData = _graphData;

- (void)setGraphData:(NSArray *)graphData
{
    _graphData = graphData;
    
    [self.sublayersArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.sublayersArray removeAllObjects];
    
    float level1Percentage = [self.graphData[0] floatValue];
    float level2Percentage = [self.graphData[1] floatValue];
    float level3Percentage = [self.graphData[2] floatValue];
    float level4Percentage = [self.graphData[3] floatValue];
    
    [self drawGradientArcWithRingIndex:0 value:level4Percentage];
    [self drawGradientArcWithRingIndex:1 value:level3Percentage];
    [self drawGradientArcWithRingIndex:2 value:level2Percentage];
    [self drawGradientArcWithRingIndex:3 value:level1Percentage];
    
    [self setPercentageLabels];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        [self setupView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self setupView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.radius = self.bounds.size.width/2 - 4 * kArcWidth;
    
    CGRect labelRect = CGRectMake(self.centerPoint.x - 3.0f,
                                  self.centerPoint.y + self.radius - kArcWidth*3/2 - 1.0,
                                  kArcWidth * 2,
                                  kArcWidth);
    
    if(self.level4PercentageLabel == nil) {
        self.level4PercentageLabel = [[PercentageCountingLabel alloc] initWithFrame:labelRect];
        [self addSubview:self.level4PercentageLabel];
    }
    
    if(self.level3PercentageLabel == nil) {
        labelRect.origin.y += kArcWidth;
        self.level3PercentageLabel = [[PercentageCountingLabel alloc] initWithFrame:labelRect];
        [self addSubview:self.level3PercentageLabel];
    }
    
    if(self.level2PercentageLabel == nil) {
        labelRect.origin.y += kArcWidth;
        self.level2PercentageLabel = [[PercentageCountingLabel alloc] initWithFrame:labelRect];
        [self addSubview:self.level2PercentageLabel];
    }
    
    if(self.level1PercentageLabel == nil) {
        labelRect.origin.y += kArcWidth;
        self.level1PercentageLabel = [[PercentageCountingLabel alloc] initWithFrame:labelRect];
        [self addSubview:self.level1PercentageLabel];
    }
}

- (void)setupView
{
    self.sublayersArray = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawTrackInContext:context ringIndex:0];
    [self drawTrackInContext:context ringIndex:1];
    [self drawTrackInContext:context ringIndex:2];
    [self drawTrackInContext:context ringIndex:3];
}

- (void)drawTrackInContext:(CGContextRef)context ringIndex:(int)index
{
    CGContextSaveGState(context);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    UIColor *trackColor = [kDesignUnfilledArcColor colorWithAlphaComponent:(0.25 * (index + 1))];
    
    // Draw circle
    CGContextSetLineWidth(context, kArcWidth);
    CGContextSetStrokeColorWithColor(context, trackColor.CGColor);
    CGPathAddArc(path, NULL,
                 self.centerPoint.x, self.centerPoint.y,
                 self.radius + index * kArcWidth,
                 0,
                 M_PI*2,
                 YES);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
    CGContextRestoreGState(context);
}

- (void)drawGradientArcWithRingIndex:(int)index value:(float)value
{
    UIColor *startColor, *endColor;
    
    switch(index)
    {
        case 3:
            startColor = kDesignGoodGradientStartColor;
            endColor = kDesignGoodGradientEndColor;
            break;
            
        case 2:
            startColor = kDesignModerateGradientStartColor;
            endColor = kDesignModerateGradientEndColor;
            break;
            
        case 1:
            startColor = kDesignUnhealthyGradientStartColor;
            endColor = kDesignUnhealthyGradientEndColor;
            break;
            
        case 0:
            startColor = kDesignVeryUnhealthyGradientStartColor;
            endColor = kDesignVeryUnhealthyGradientEndColor;
            break;
            
        default:
            break;
    }
    
    CAShapeLayer *arcLayer = [CAShapeLayer layer];
    arcLayer.path = [UIBezierPath bezierPathWithArcCenter:self.centerPoint
                                                   radius:self.radius  + index * kArcWidth
                                               startAngle:M_PI_2
                                                 endAngle:M_PI * 2 * value + M_PI_2
                                                clockwise:YES].CGPath;
    arcLayer.lineCap = kCALineCapButt;
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor = [UIColor purpleColor].CGColor;
    arcLayer.lineWidth = kArcWidth;
    [self.sublayersArray addObject:arcLayer];
    [self.layer addSublayer:arcLayer];
    
    CAGradientLayer *arcGradientLayer = [CAGradientLayer layer];
    arcGradientLayer.frame = self.bounds;
    arcGradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    arcGradientLayer.startPoint = CGPointMake(0.5, 1.0);
    arcGradientLayer.endPoint = CGPointMake(0.5, 0.0);
    arcGradientLayer.mask = arcLayer;
    [self.sublayersArray addObject:arcGradientLayer];
    [self.layer addSublayer:arcGradientLayer];
    
    CABasicAnimation *animation = (CABasicAnimation *)[arcLayer animationForKey:@"strokeEndAnimation"];
    animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = kArcAnimationDuration;
    animation.repeatCount = 1.0;
    animation.removedOnCompletion = YES;
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue   = [NSNumber numberWithFloat:1.0f];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [arcLayer addAnimation:animation forKey:@"strokeEndAnimation"];
}

- (void)setPercentageLabels
{
    int level1Percentage = [self.graphData[0] floatValue] * 100;
    int level2Percentage = [self.graphData[1] floatValue] * 100;
    int level3Percentage = [self.graphData[2] floatValue] * 100;
    int level4Percentage = [self.graphData[3] floatValue] * 100;
    
    [self.level1PercentageLabel countFromZeroPercentToPercentage:level1Percentage withDuration:kPercentageAnimationDuration];
    [self.level2PercentageLabel countFromZeroPercentToPercentage:level2Percentage withDuration:kPercentageAnimationDuration];
    [self.level3PercentageLabel countFromZeroPercentToPercentage:level3Percentage withDuration:kPercentageAnimationDuration];
    [self.level4PercentageLabel countFromZeroPercentToPercentage:level4Percentage withDuration:kPercentageAnimationDuration];
}


@end
