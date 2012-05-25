//
//  GraphView.h
//  rr_assignment_1
//
//  Created by Robert Rivera on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;
@protocol GraphViewDelegate

- (double) findYfor: (double) x :(GraphView*) sender;

@end

@interface GraphView : UIView
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;

@property (nonatomic,weak) IBOutlet id<GraphViewDelegate> delegate;

- (void) pinch: (UIPinchGestureRecognizer *)gesture;
- (void) pan: (UIPanGestureRecognizer*) gesture;
- (void) tap: (UITapGestureRecognizer*) gesture;
@end
