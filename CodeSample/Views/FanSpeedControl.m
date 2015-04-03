//
//  FanSpeedControl.m
//  
//
//  Created by Michael Shin on 2/10/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "FanSpeedControl.h"
#import "DesignUtility.h"
#import "Purifier.h"

#define kArcLeftTopEdgePadding 120.0
#define kArcRightBottomEdgePadding 40.0
#define kArcInnerShadowRadius 0.4
#define kNumberOfLevels 5.0
#define kMinimumTouchArea 58.0 // Apple recommends at least 44

@interface FanSpeedControl()
@property (nonatomic, assign) CGFloat angle;
@end

@implementation FanSpeedControl

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
    self.arcCenter = CGPointMake(self.bounds.size.width - kArcRightBottomEdgePadding,
                                 self.bounds.size.height - kArcRightBottomEdgePadding);
    self.radius = MIN(self.arcCenter.x - kArcLeftTopEdgePadding, self.arcCenter.y - kArcLeftTopEdgePadding);
}

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    self.angle = 0.0;
    self.fanSpeed = 0;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // TODO: arc track inner shadow
    // Draw arc track
    UIBezierPath *arcTrack = [UIBezierPath bezierPath];
    
    [arcTrack addArcWithCenter:self.arcCenter
                           radius:self.radius
                       startAngle:-M_PI
                         endAngle:-M_PI_2
                        clockwise:YES];
    [arcTrack setLineCapStyle:kCGLineCapRound];
    [arcTrack setLineWidth:kFanSpeedControlArcWidth];
    [kDesignUnfilledArcColor set];
    [arcTrack stroke];
    
    //[self drawInnerShadowInContext:context
    //                      withPath:arcTrack.CGPath
    //                   shadowColor:[UIColor blackColor].CGColor
    //                        offset:CGSizeMake(0, 0)
    //                    blurRadius:4.0];
    
    [self drawGradientArcInContext:context];
}

- (void)drawInnerShadowInContext:(CGContextRef)context
                        withPath:(CGPathRef)path
                     shadowColor:(CGColorRef)shadowColor
                          offset:(CGSize)offset
                      blurRadius:(CGFloat)blurRadius
{
    UIBezierPath *shadowPath, *maskPath;
    
    // Outer inner shadow
    CGContextSaveGState(context);
    
    shadowPath = [UIBezierPath bezierPathWithArcCenter:self.arcCenter
                                                radius:self.radius + kFanSpeedControlArcWidth/2 + kArcInnerShadowRadius
                                            startAngle:-M_PI
                                              endAngle:-M_PI_2
                                             clockwise:YES];
    [shadowPath setLineCapStyle:kCGLineCapRound];
    
    maskPath = [UIBezierPath bezierPathWithArcCenter:self.arcCenter
                                              radius:self.radius + kFanSpeedControlArcWidth/2
                                          startAngle:-M_PI
                                            endAngle:-M_PI_2
                                           clockwise:YES];
    [maskPath setLineCapStyle:kCGLineCapRound];
    
    CGContextAddRect(context, CGPathGetBoundingBox(shadowPath.CGPath));
    CGContextAddPath(context, maskPath.CGPath);
    CGContextEOClip(context);
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddPath(context, shadowPath.CGPath);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 4.0, [UIColor blackColor].CGColor);
    CGContextSetBlendMode (context, kCGBlendModeNormal);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    // Inner inner shadow
    CGContextSaveGState(context);
    
    shadowPath = [UIBezierPath bezierPathWithArcCenter:self.arcCenter
                                                radius:self.radius - kFanSpeedControlArcWidth/2 + kArcInnerShadowRadius
                                            startAngle:-M_PI
                                              endAngle:-M_PI_2
                                             clockwise:YES];
    [shadowPath setLineCapStyle:kCGLineCapRound];
    
    maskPath = [UIBezierPath bezierPathWithArcCenter:self.arcCenter
                                              radius:self.radius - kFanSpeedControlArcWidth/2
                                          startAngle:-M_PI
                                            endAngle:-M_PI_2
                                           clockwise:YES];
    [maskPath setLineCapStyle:kCGLineCapRound];
    
    CGContextAddRect(context, CGPathGetBoundingBox(shadowPath.CGPath));
    CGContextAddPath(context, maskPath.CGPath);
    CGContextEOClip(context);
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddPath(context, shadowPath.CGPath);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 4.0, [UIColor blackColor].CGColor);
    CGContextSetBlendMode (context, kCGBlendModeNormal);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}

- (void)drawGradientArcInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    
    // Draw arc
    CGMutablePathRef arcPath = CGPathCreateMutable();
    CGPathAddArc(arcPath, NULL,
                 self.arcCenter.x, self.arcCenter.y,
                 self.radius,
                 -M_PI,
                 -M_PI + self.angle,
                 NO);
    
    // Create stroked copy with rounded caps
    CGPathRef strokedArcPath = CGPathCreateCopyByStrokingPath(arcPath, NULL,
                                                              kFanSpeedControlArcWidth,
                                                              kCGLineCapRound,
                                                              kCGLineJoinMiter,
                                                              10);
    
    // Fill arc with gradient
    CGGradientRef gradient = [DesignUtility controlArcGradientRef];
    CGContextAddPath(context, strokedArcPath);
    CGContextClip(context);
    
    CGRect boundingBox = CGPathGetBoundingBox(strokedArcPath);
    CGPoint gradientStart = CGPointMake(CGRectGetMinX(boundingBox), CGRectGetMaxY(boundingBox));
    CGPoint gradientEnd   = CGPointMake(CGRectGetMaxX(boundingBox), CGRectGetMinY(boundingBox));
    
    CGContextDrawLinearGradient(context, gradient, gradientStart, gradientEnd, 0);
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat touchMargin = MAX(kFanSpeedControlArcWidth, kMinimumTouchArea) / 2;
    
    if(point.x < self.arcCenter.x + touchMargin && point.y < self.arcCenter.y + touchMargin) {
        CGFloat xDist = self.arcCenter.x - point.x;
        CGFloat yDist = self.arcCenter.y - point.y;
        double distance = sqrt(xDist * xDist + yDist * yDist);
        return distance >= (self.radius - touchMargin) && distance <= (self.radius + touchMargin);
    }
    else {
        return NO;
    }
}

- (CGFloat)angleForPoint:(CGPoint)point
{
    float d_x = self.arcCenter.x - point.x;
    float d_y = self.arcCenter.y - point.y;
    float angle = atan2f(d_y, d_x);
    
    if(angle > M_PI_2) {
        angle = M_PI_2;
    }
    else if(angle < 0) {
        angle = 0;
    }
    
    return angle;
}

- (CGPoint)pointForAngle:(float)angle
{
    float x = self.arcCenter.x - self.radius * cosf(angle);
    float y = self.arcCenter.y - self.radius * sinf(angle);
    
    return CGPointMake(x, y);
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    [self handleTouch:touch endTracking:NO];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    [self handleTouch:touch endTracking:YES];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)handleTouch:(UITouch *)touch endTracking:(BOOL)endTracking
{
    CGPoint touchPoint = [touch locationInView:self];
    self.angle = [self angleForPoint:touchPoint];
    
    if(endTracking) {
        float arcSegmentSize = M_PI_2/kFanSpeedControlNumberOfSegments;
        float radiansToPreviousLevel = fmodf(self.angle, arcSegmentSize);
        float radiansToNextLevel = arcSegmentSize - radiansToPreviousLevel;
        
        if(radiansToNextLevel < arcSegmentSize/2) {
            self.angle += radiansToNextLevel;
        }
        else {
            self.angle -= radiansToPreviousLevel;
        }
        
        self.fanSpeed = (PurifierStateFanSpeed)(kFanSpeedControlNumberOfSegments * self.angle/M_PI_2);
    }
    
    [self setNeedsDisplay];
}
/*
- (void)setPurifierState:(PurifierState *)state
{
    self.fanSpeed = state.fanSpeed;
    self.angle = state.fanSpeed/kFanSpeedControlNumberOfSegments * M_PI_2;
    [self setNeedsDisplay];
}
*/

@end
