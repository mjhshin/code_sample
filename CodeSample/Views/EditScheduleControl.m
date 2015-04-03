//
//  AddScheduleControl.m
//  
//
//  Created by Michael Shin on 2/24/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "EditScheduleControl.h"
#import "DesignUtility.h"

#define kHandleWidthHeight 44.0
#define kCirclePadding 20.0
#define kCircleWidth 14.0
#define kInnerShadowRadius 4.5
#define kArcEndTouchRadius 44.0
#define kHandleTouchRadius 44.0
#define kRadiusFromHandleToCircle 24.5
#define kRadiusFromSmallRulerToCircle 24.0
#define kRadiusFromLargeRulerToCircle 20.0
#define kFloatSameValuePrecisionThreshold 0.001

@interface EditScheduleControl()

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat startAngleFromNorth;
@property (nonatomic, assign) CGFloat endAngleFromNorth;
@property (nonatomic, assign) BOOL trackingStartHandle;
@property (nonatomic, strong) UIImageView *startHandle;
@property (nonatomic, strong) UIImageView *endHandle;
@end

@implementation EditScheduleControl

@synthesize startValue = _startValue;
@synthesize endValue = _endValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        //[self setupView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        //[self setupView];
    }
    
    return self;
}

- (void)setStartValue:(float)value
{
    _startValue = value;
    _startAngleFromNorth = [self angleFromNorthForValue:_startValue];
    [self setNeedsDisplay];
}

- (void)setEndValue:(float)value
{
    _endValue = value;
    _endAngleFromNorth = [self angleFromNorthForValue:_endValue];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    // TEMP workaround
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self setupView];
}

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    
    self.radius = MIN(self.bounds.size.width, self.bounds.size.height)/2 - kCirclePadding;
    
    // TODO: Set default handle positions
    self.startAngleFromNorth = 7.0/8 * (2 * M_PI); // 9pm
    self.endAngleFromNorth = 1.0/8 * (2 * M_PI);   // 3am
    
    self.trackingStartHandle = YES;
    self.centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    self.startHandle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kHandleWidthHeight, kHandleWidthHeight)];
    self.startHandle.contentMode = UIViewContentModeCenter;
    self.startHandle.image = [UIImage imageNamed:@"dot_selected"];
    
    self.endHandle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kHandleWidthHeight, kHandleWidthHeight)];
    self.endHandle.contentMode = UIViewContentModeCenter;
    self.endHandle.image = [UIImage imageNamed:@"dot_selected"];
    
    for(int i = 0; i < 48; i++) {
        CGFloat angle = i * 2 * M_PI / 48;
        float standardAngle = [self standardAngleForAngleFromNorth:angle];
        CGPoint point = [self pointForAngleFromNorth:angle];
        UIImageView *ruler;
        
        if(i % 2 == 0) {
            ruler = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_ruler_large"]];
            ruler.center = CGPointMake(point.x - kRadiusFromLargeRulerToCircle * cosf(standardAngle),
                                       point.y - kRadiusFromLargeRulerToCircle * sinf(standardAngle));
        }
        else {
            ruler = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_ruler_small"]];
            ruler.center = CGPointMake(point.x - kRadiusFromSmallRulerToCircle * cosf(standardAngle),
                                       point.y - kRadiusFromSmallRulerToCircle * sinf(standardAngle));
        }
        ruler.transform = CGAffineTransformMakeRotation(angle);
        [self addSubview:ruler];
    }

    [self addSubview:self.startHandle];
    [self addSubview:self.endHandle];
    
    [self setValues];
}

- (void)setValues
{
    if(self.startAngleFromNorth < 0)
        self.startAngleFromNorth += 2 * M_PI;
    if(self.endAngleFromNorth < 0)
        self.endAngleFromNorth += 2 * M_PI;
    
    self.startAngleFromNorth = fmodf(self.startAngleFromNorth, 2 * M_PI);
    self.endAngleFromNorth = fmodf(self.endAngleFromNorth, 2 * M_PI);
    
    self.startValue = self.startAngleFromNorth / (2 * M_PI);
    self.endValue = self.endAngleFromNorth / (2 * M_PI);
}

#pragma mark - Draw methods

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawCircleTrackInContext:context];
    
    [self drawGradientArcInContext:context];
    
    [self layoutHandles];
}

- (void)drawCircleTrackInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    // Draw circle
    CGContextSetLineWidth(context, kCircleWidth);
    CGContextSetStrokeColorWithColor(context, kDesignUnfilledArcColor.CGColor);
    CGPathAddArc(path, NULL,
                 self.centerPoint.x, self.centerPoint.y,
                 self.radius,
                 0,
                 M_PI*2,
                 YES);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
    CGContextRestoreGState(context);
}

- (void)drawGradientArcInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    
    // Draw arc
    CGMutablePathRef arcPath = CGPathCreateMutable();
    CGPathAddArc(arcPath, NULL,
                 self.centerPoint.x, self.centerPoint.y,
                 self.radius,
                 self.startAngleFromNorth - M_PI_2,
                 self.endAngleFromNorth - M_PI_2,
                 NO);
    
    // Create stroked copy with rounded caps
    CGPathRef strokedArcPath = CGPathCreateCopyByStrokingPath(arcPath, NULL,
                                                              kCircleWidth,
                                                              kCGLineCapRound,
                                                              kCGLineJoinMiter,
                                                              10);
    
    // Fill arc with gradient
    CGGradientRef gradient = [DesignUtility controlArcGradientRef];
    CGContextAddPath(context, strokedArcPath);
    CGContextClip(context);
    
    CGRect boundingBox = CGPathGetBoundingBox(strokedArcPath);
    CGPoint gradientStart = CGPointMake(CGRectGetMinX(boundingBox), CGRectGetMaxY(boundingBox));
    CGPoint gradientEnd = CGPointMake(CGRectGetMaxX(boundingBox), CGRectGetMinY(boundingBox));
    
    CGContextDrawLinearGradient(context, gradient, gradientStart, gradientEnd, 0);
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
}

- (void)layoutHandles
{
    CGPoint startHandleCenter = [self pointForAngleFromNorth:self.startAngleFromNorth];
    CGPoint endHandleCenter = [self pointForAngleFromNorth:self.endAngleFromNorth];
    
    float startStandardAngle = [self standardAngleForAngleFromNorth:self.startAngleFromNorth];
    float endStandardAngle = [self standardAngleForAngleFromNorth:self.endAngleFromNorth];
    
    self.startHandle.center = CGPointMake(startHandleCenter.x - kRadiusFromHandleToCircle * cosf(startStandardAngle),
                                          startHandleCenter.y - kRadiusFromHandleToCircle * sinf(startStandardAngle));
    
    self.endHandle.center = CGPointMake(endHandleCenter.x - kRadiusFromHandleToCircle * cosf(endStandardAngle),
                                        endHandleCenter.y - kRadiusFromHandleToCircle * sinf(endStandardAngle));
}

#pragma mark - UIControl methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint arcStartCenter = [self pointForAngleFromNorth:self.startAngleFromNorth];
    BOOL pointInsideArcStart = [self pointInsideArcTouchArea:point withCenter:arcStartCenter withHandleFrame:self.startHandle.center];
    
    CGPoint arcEndCenter = [self pointForAngleFromNorth:self.endAngleFromNorth];
    BOOL pointInsideArcEnd = [self pointInsideArcTouchArea:point withCenter:arcEndCenter withHandleFrame:self.endHandle.center];
    
    return pointInsideArcStart || pointInsideArcEnd;
}

- (BOOL)pointInsideArcTouchArea:(CGPoint)point withCenter:(CGPoint)center withHandleFrame:(CGPoint)handleCenter
{
    CGFloat xDistArc = center.x - point.x;
    CGFloat yDistArc = center.y - point.y;
    double distanceFromArc = sqrt(xDistArc * xDistArc + yDistArc * yDistArc);
    
    CGFloat xDistHandle = handleCenter.x - point.x;
    CGFloat yDistHandle = handleCenter.y - point.y;
    double distanceFromHandle = sqrt(xDistHandle * xDistHandle + yDistHandle * yDistHandle);
    
    return distanceFromArc <= kArcEndTouchRadius || distanceFromHandle <= kHandleTouchRadius;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint startHandleCenter = [self pointForAngleFromNorth:self.startAngleFromNorth];
    self.trackingStartHandle = [self pointInsideArcTouchArea:touchPoint withCenter:startHandleCenter withHandleFrame:self.startHandle.center];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    [self handleTouch:touch endTracking:NO];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
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
    CGFloat newAngle = [self angleFromNorthForPoint:touchPoint];
    CGFloat oldAngle;
    
    float radiansFor30Mins = 2 * M_PI / 48;
    
    if(self.trackingStartHandle) {
        oldAngle = self.startAngleFromNorth;
        self.startAngleFromNorth = newAngle;
        
        if(endTracking) { // Snap to closest 30 min mark
            float startAngleMod = fmodf(self.startAngleFromNorth, radiansFor30Mins);
            
            if(startAngleMod > radiansFor30Mins / 2) {
                self.startAngleFromNorth += (radiansFor30Mins - startAngleMod);
                
                if(ABS(self.startAngleFromNorth - self.endAngleFromNorth) < kFloatSameValuePrecisionThreshold)
                    self.startAngleFromNorth -= radiansFor30Mins;
            }
            else {
                self.startAngleFromNorth -= startAngleMod;
                
                if(ABS(self.startAngleFromNorth - self.endAngleFromNorth) < kFloatSameValuePrecisionThreshold)
                    self.startAngleFromNorth += radiansFor30Mins;
            }
        }
    }
    else {
        oldAngle = self.endAngleFromNorth;
        self.endAngleFromNorth = newAngle;
        
        if(endTracking) { // Snap to closest 30 min mark
            float endAngleMod = fmodf(self.endAngleFromNorth, radiansFor30Mins);
            
            if(endAngleMod > radiansFor30Mins / 2) {
                self.endAngleFromNorth += (radiansFor30Mins - endAngleMod);
                
                if(ABS(self.startAngleFromNorth - self.endAngleFromNorth) < kFloatSameValuePrecisionThreshold)
                    self.endAngleFromNorth -= radiansFor30Mins;
            }
            else {
                self.endAngleFromNorth -= endAngleMod;
                
                if(ABS(self.startAngleFromNorth - self.endAngleFromNorth) < kFloatSameValuePrecisionThreshold)
                    self.endAngleFromNorth += radiansFor30Mins;
            }
        }
    }
    
    [self setValues];
    
    [self setNeedsDisplay];
}

#pragma mark - Conversion functions

- (CGFloat)angleFromNorthForValue:(float)value
{
    return 2 * M_PI * value;
}

- (CGFloat)angleFromNorthForPoint:(CGPoint)point
{
    float d_x = self.centerPoint.x - point.x;
    float d_y = self.centerPoint.y - point.y;
    float angle = atan2f(d_y, d_x);
    
    if(angle < 0)
        angle += 2 * M_PI;
    
    return [self angleFromNorthForStandardAngle:angle];
}

- (CGPoint)pointForAngleFromNorth:(float)angle
{
    float standardAngle = [self standardAngleForAngleFromNorth:angle];
    float x = self.centerPoint.x - self.radius * cosf(standardAngle);
    float y = self.centerPoint.y - self.radius * sinf(standardAngle);
    
    return CGPointMake(x, y);
}

- (CGFloat)angleFromNorthForStandardAngle:(float)angle
{
    angle -= M_PI_2;
    
    if(angle < 0)
        angle += 2 * M_PI;
    
    return angle;
}

- (float)standardAngleForAngleFromNorth:(CGFloat)angle
{
    angle += M_PI_2;
    
    if(angle > 2 * M_PI)
        angle -= 2 * M_PI;
    
    return angle;
}

@end
