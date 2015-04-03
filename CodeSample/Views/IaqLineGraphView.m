//
//  IaqLineGraphView.m
//  
//
//  Created by Michael Shin on 3/27/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "IaqLineGraphView.h"
#import "DesignUtility.h"

#define kIaqLineGraphViewLeftPadding 6.0
#define kIaqLineGraphViewRightPadding 2.0
#define kIaqLineGraphViewVerticalPadding 0.0
#define kIaqLineGraphViewSmoothSlopeThreshold 0.01
#define kIaqLineGraphViewSmoothVerticalThreshold 1.0
#define kIaqLineGraphViewLineWidth 3.5
#define kIaqLineGraphViewAnimationDuration 0.4

@interface IaqGraphPoint : NSObject

@property (nonatomic, assign) CGPoint position;

@end

@interface IaqLineGraphView()

@property (nonatomic, strong) NSArray *graphPoints;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIBezierPath *graphLinePath;

@end

@implementation IaqGraphPoint

- (id)init
{
    self = [super init];
    if (self) {
        _position = CGPointZero;
    }
    return self;
}

- (NSComparisonResult)compare:(IaqGraphPoint *)otherObject
{
    return self.position.x > otherObject.position.x;
}

@end

@implementation IaqLineGraphView

@synthesize graphData = _graphData;

- (void)setGraphData:(NSArray *)graphData
{
    _graphData = graphData;
    
    [self setNeedsDisplay];
}

- (void)initDataPoints
{
    CGFloat pointSpace = (self.bounds.size.width - kIaqLineGraphViewLeftPadding - kIaqLineGraphViewRightPadding) / (kIaqLineGraphViewNumDataPoints - 1);
    CGFloat xOffset = kIaqLineGraphViewLeftPadding;
    
    NSMutableArray *dataPoints = [NSMutableArray array];
    
    // Necessary to create points even when no data for initial animation
    if(self.graphData == nil) {
        for (int i = 0; i < kIaqLineGraphViewNumDataPoints; i++) {
            IaqGraphPoint *dataPoint = [[IaqGraphPoint alloc] init];
            dataPoint.position = CGPointMake(xOffset, self.bounds.size.height - kIaqLineGraphViewVerticalPadding);
            [dataPoints addObject:dataPoint];
            
            xOffset += pointSpace;
        }
    }
    else {
        for (int i = 0; i < kIaqLineGraphViewNumDataPoints; i++) {
            CGFloat rawValueY =  [[self.graphData objectAtIndex:i] floatValue];
            CGFloat graphValueY = rawValueY * (self.bounds.size.height - 2 * kIaqLineGraphViewVerticalPadding) + kIaqLineGraphViewVerticalPadding;
            
            IaqGraphPoint *dataPoint = [[IaqGraphPoint alloc] init];
            dataPoint.position = CGPointMake(xOffset, graphValueY);
            [dataPoints addObject:dataPoint];
            
            xOffset += pointSpace;
        }
    }
    
    self.graphPoints = [NSArray arrayWithArray:dataPoints];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    if(self.backgroundImageView == nil) {
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iaq_line_graph_background"]];
        self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self insertSubview:self.backgroundImageView atIndex:0];
    }
    self.backgroundImageView.frame = self.bounds;
    
    if(self.gradientLayer == nil) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)(kDesignGoodGradientStartColor.CGColor),
                                      (__bridge id)(kDesignGoodGradientEndColor.CGColor),
                                      (__bridge id)(kDesignModerateGradientStartColor.CGColor),
                                      (__bridge id)(kDesignModerateGradientEndColor.CGColor),
                                      (__bridge id)(kDesignUnhealthyGradientEndColor.CGColor),
                                      (__bridge id)(kDesignUnhealthyGradientStartColor.CGColor),
                                      (__bridge id)(kDesignVeryUnhealthyGradientStartColor.CGColor),
                                      (__bridge id)(kDesignVeryUnhealthyGradientEndColor.CGColor)];
        self.gradientLayer.startPoint = CGPointMake(0.5, 1.0);
        self.gradientLayer.endPoint = CGPointMake(0.5, 0.0);
        [self.layer addSublayer:self.gradientLayer];
    }
    self.gradientLayer.frame = self.bounds;
    
    if(self.maskLayer == nil) {
        self.maskLayer = [CAShapeLayer layer];
        self.maskLayer.strokeColor = [UIColor redColor].CGColor;
        self.maskLayer.fillColor = [UIColor clearColor].CGColor;
        self.maskLayer.path = self.graphLinePath.CGPath;
        [self.layer addSublayer:self.maskLayer];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self initDataPoints];
    
    UIBezierPath *oldGraphLinePath = [self.graphLinePath copy];
    self.graphLinePath = [UIBezierPath bezierPath];
    self.graphLinePath.miterLimit = -5.0;
    
    CGFloat previousSlope = 0.0f;
    
    NSUInteger index = 0;
    
    IaqGraphPoint *previousLineGraphPoint = nil;
    
    for (IaqGraphPoint *lineGraphPoint in self.graphPoints)
    {
        if (index == 0)
        {
            [self.graphLinePath moveToPoint:CGPointMake(lineGraphPoint.position.x, lineGraphPoint.position.y)];
        }
        else
        {
            IaqGraphPoint *nextLineGraphPoint = nil;
            
            if (index != (self.graphPoints.count - 1)) {
                nextLineGraphPoint = [self.graphPoints objectAtIndex:(index + 1)];
            }
            
            CGFloat nextSlope;
            
            if(nextLineGraphPoint != nil) {
                nextSlope = (nextLineGraphPoint.position.y - lineGraphPoint.position.y) / (nextLineGraphPoint.position.x - lineGraphPoint.position.x);
            }
            else {
                nextSlope = previousSlope;
            }
            
            CGFloat currentSlope = ((lineGraphPoint.position.y - previousLineGraphPoint.position.y)) / (lineGraphPoint.position.x - previousLineGraphPoint.position.x);
            
            BOOL curvedToNextSlope = ((currentSlope >= (nextSlope + kIaqLineGraphViewSmoothSlopeThreshold)) ||
                                      (currentSlope <= (nextSlope - kIaqLineGraphViewSmoothSlopeThreshold)));
            
            BOOL curvedToPreviousSlope = ((currentSlope >= (previousSlope + kIaqLineGraphViewSmoothSlopeThreshold)) ||
                                          (currentSlope <= (previousSlope - kIaqLineGraphViewSmoothSlopeThreshold)));
            
            BOOL deltaFromPreviousYAboveThreshld = ((lineGraphPoint.position.y >= previousLineGraphPoint.position.y + kIaqLineGraphViewSmoothVerticalThreshold) ||
                                                    (lineGraphPoint.position.y <= previousLineGraphPoint.position.y - kIaqLineGraphViewSmoothVerticalThreshold));
            
            if (curvedToNextSlope && curvedToPreviousSlope && deltaFromPreviousYAboveThreshld) {
                CGFloat deltaX = lineGraphPoint.position.x - previousLineGraphPoint.position.x;
                CGFloat controlPointX = previousLineGraphPoint.position.x + (deltaX / 2);
                
                CGPoint controlPoint1 = CGPointMake(controlPointX, previousLineGraphPoint.position.y);
                CGPoint controlPoint2 = CGPointMake(controlPointX, lineGraphPoint.position.y);
                
                [self.graphLinePath addCurveToPoint:CGPointMake(lineGraphPoint.position.x, lineGraphPoint.position.y)
                                      controlPoint1:controlPoint1
                                      controlPoint2:controlPoint2];
            }
            else {
                [self.graphLinePath addLineToPoint:CGPointMake(lineGraphPoint.position.x, lineGraphPoint.position.y)];
            }
            
            previousSlope = currentSlope;
        }
        
        previousLineGraphPoint = lineGraphPoint;
        index++;
    }
    
    self.maskLayer.path = self.graphLinePath.CGPath;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id)[oldGraphLinePath CGPath];
    pathAnimation.toValue = (__bridge id)[self.graphLinePath CGPath];
    pathAnimation.duration = kIaqLineGraphViewAnimationDuration;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.maskLayer addAnimation:pathAnimation forKey:@"pathAnimation"];
    
    self.gradientLayer.mask = self.maskLayer;
}

@end
