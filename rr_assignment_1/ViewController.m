//
//  ViewController.m
//  rr_assignment_1
//
//  Created by Robert Rivera on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Brain.h"

@interface ViewController()

@property (nonatomic) BOOL entryInProgress;
@property (nonatomic,strong) Brain *brain;

@end

@implementation ViewController

@synthesize display;
@synthesize details = _details;
@synthesize entryInProgress = _entryInProgress;
@synthesize brain = _brain;

- (Brain*) brain {
    
    if(!_brain)
        _brain = [[Brain alloc] init];
    
    return _brain;
}

- (IBAction)digitPressed:(UIButton*)sender {
    
    // Append to existing string.
    if (self.entryInProgress) {
        
        // Ignore multiple attempts to enter "."
        if (!([sender.currentTitle isEqualToString:@"."] &&
              [self.display.text rangeOfString:@"."].location != NSNotFound)) {
            self.display.text = [self.display.text stringByAppendingString:sender.currentTitle];
        }
        
    } else {
        if ([sender.currentTitle isEqualToString:@"."]){
            self.display.text = @"0.";
        } else {
            self.display.text = sender.currentTitle;
        }
        self.entryInProgress = YES;
    }
    
}

- (void) appendDetailString: (NSString*) value {
    
    if (self.details.text.length == 0)
        self.details.text = value;
    else
        self.details.text = [self.details.text stringByAppendingString:[NSString stringWithFormat:@" %@",value]];
}

- (IBAction)enterPressed {

    [self.brain pushOperand:[display.text doubleValue]];
    self.entryInProgress = NO;
    
    [self appendDetailString:display.text];
}

- (IBAction)operationPressed:(UIButton*)sender {

    // Add current entered value to brain.
    if (self.entryInProgress)
        [self enterPressed];
    
    [self appendDetailString:[sender currentTitle]];
    self.display.text = [NSString stringWithFormat:@"%f",[self.brain performOperation:[sender currentTitle]]];
    
    
}

- (IBAction)clearPressed {
    
    self.display.text = @"0";
    self.details.text = @"";
    self.entryInProgress = NO;
    [self.brain clear];
    
}

- (void)viewDidUnload {
    [self setDetails:nil];
    [super viewDidUnload];
}
@end
