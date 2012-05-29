//
//  GraphVC.m
//  rr_assignment_1
//
//  Created by Robert Rivera on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphVC.h"
#import "GraphView.h"
#import "Brain.h"

@interface GraphVC() <GraphViewDelegate>
       
@property (nonatomic,weak) IBOutlet GraphView *graphView;
@end

@implementation GraphVC

@synthesize graphView = _graphView;
@synthesize program = _program;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Override setter to set up everything for the custon graph view.
- (void) setGraphView:(GraphView *)graphView {
    
    _graphView = graphView;
    CGPoint midpoint;
    midpoint.x = self.graphView.bounds.origin.x + self.graphView.bounds.size.width/2;
    midpoint.y = self.graphView.bounds.origin.y + self.graphView.bounds.size.height/2;
    self.graphView.origin = midpoint;
    self.graphView.scale = (CGFloat) 5;
    // Set up gesture recognizers here.
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer* uitgr = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    [uitgr setNumberOfTapsRequired:3];
    [uitgr setNumberOfTouchesRequired:1];
    [self.graphView addGestureRecognizer:uitgr];
    self.graphView.delegate = self;
    
}
- (void) setProgram:(NSArray *)program {
    
    _program = [program copy];
    [self.graphView setNeedsDisplay];
    
}


#pragma mark - protocol implementation
- (double) findYfor: (double) x :(GraphView*) sender {
    
    NSNumber* nsx = [[NSNumber alloc] initWithDouble:x];
    NSArray* value = [[NSArray alloc] initWithObjects:nsx, nil];
    NSArray* key = [[NSArray alloc] initWithObjects:@"x", nil];
    NSDictionary *vars = [[NSDictionary alloc] initWithObjects:value forKeys:key];
    
    return [Brain runProgram:self.program usingVariableValues:vars];
    
}


@end
