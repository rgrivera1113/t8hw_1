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
}

- (void) pan: (UIPanGestureRecognizer*) gesture {
    
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded){
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, 
                                  self.origin.y + translation.y);
        [gesture setTranslation: CGPointMake(0, 0) inView:self];
    }
    
}

- (void) tap: (UITapGestureRecognizer*) gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded)
        [self setOrigin:[gesture locationInView:self]];
        
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Set up the graph with the current origin and scale.
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint: self.origin scale:self.scale];
    
    // Find the range of x.
    // Set path of graph for x.
    // Draw line.
}


@end
