//
//  GraphView.m
//  rr_assignment_1
//
//  Created by Robert Rivera on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize delegate = _delegate;
@synthesize origin = _origin;
@synthesize scale = _scale;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setScale:(CGFloat)scale {
    
    if (_scale != scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
    
}

- (void) setOrigin:(CGPoint)origin {
    
    if (_origin.x != origin.x || _origin.y != origin.y) {
        _origin = origin;
        [self setNeedsDisplay];
    }
    
}

#pragma mark - Gesture recognizers.

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    
    
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; 
        gesture.scale = 1;
    }
    
//    if (gesture.state == UIGestureRecognizerStateEnded) {
//        
//        NSLog(@"Origin after pan: x = %f, y = %f",self.origin.x, self.origin.y);
//        
//    }
}

- (void) pan: (UIPanGestureRecognizer*) gesture {
    
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded){
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, 
                                  self.origin.y + translation.y);
        [gesture setTranslation: CGPointMake(0, 0) inView:self];
    }
    
//    if (gesture.state == UIGestureRecognizerStateEnded) {
//        
//        NSLog(@"Origin at end of pan: x = %f, y = %f",self.origin.x, self.origin.y);
//        
//    }
    
}

- (void) tap: (UITapGestureRecognizer*) gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded)
        [self setOrigin:[gesture locationInView:self]];
        
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    [AxesDrawer drawAxesInRect:self.bounds originAtPoint: self.origin scale:self.scale];

    //Setup parameters. 
    //Find X Units on screen. (points in Display / points per unit)
    CGFloat displayedUnits = self.bounds.size.width / self.scale;
    // Find the granularity of x.  Advance x by point, not by value.
    CGFloat granularity = (1.0f/self.scale)/self.contentScaleFactor;
    
    /* Find range of x value on screen. 
       Cases:
        Origin exists inside display.
        Origin exists outside left bound.
        Origin exists outside right bound.
       Lowest x value will be highest x - displayed units.
     */
    CGFloat ceiling = ((CGFloat)self.bounds.size.width - self.origin.x) / self.scale;
    CGFloat floor = ceiling - displayedUnits;
    // Move to first position.
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);

    CGFloat yValue = self.origin.y - [self.delegate findYfor:floor :self] * self.scale;
    CGFloat xValue = self.origin.x + floor * self.scale;
    
    CGContextMoveToPoint(context, xValue, yValue);
    
    /* Traverse range of x and draw a point at (x.y) */
    while (floor <= ceiling) {
        
        yValue = self.origin.y - [self.delegate findYfor:floor :self] * self.scale;
        CGContextAddLineToPoint(context, self.origin.x + floor * self.scale, yValue);
        floor += granularity;
    }
    
	CGContextStrokePath(context);
    
    
    
    // Find the range of x.
    // x = (value at left edge .. value at right edge)
    // Scale = points per unit.  Example:  1 = 1 point per unit.  5 = 5 points per unit.
    // To draw, x = units * points per unit.
    // Solve for x.  The number of points in display / points per unit.
    
    
    // Set path of graph for x.
    // Draw line.
}


@end
