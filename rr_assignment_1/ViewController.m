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
@property (nonatomic,strong) NSMutableDictionary *variables;

@end

@implementation ViewController

@synthesize display;
@synthesize details = _details;
@synthesize entryInProgress = _entryInProgress;
@synthesize brain = _brain;
@synthesize variables = _variables;

- (Brain*) brain {
    
    if(!_brain)
        _brain = [[Brain alloc] init];
    
    return _brain;
}

- (NSMutableDictionary*) variables {
    
    if(!_variables) {
        
        NSNumber* prototype = [[NSNumber alloc] initWithDouble:0];
        // Set up default keys and values (readability.)
        NSArray* keys = [[NSArray alloc] initWithObjects:@"a",@"b",@"x", nil];
        NSArray* values = [[NSArray alloc] initWithObjects:[prototype copy],
                           [prototype copy],[prototype copy], nil];
        _variables = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
        
    }
    
    return _variables;
    
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
    
    self.details.text = [[self.brain class] descriptionOfProgram:[self.brain program]];
}

- (IBAction)operationPressed:(UIButton*)sender {

    // Add current entered value to brain.
    if (self.entryInProgress)
        [self enterPressed];
    
    //[self appendVariableString];
    
    self.display.text = [NSString stringWithFormat:@"%f",
                         [self.brain performOperation:[sender currentTitle] 
                                        withVariables:self.variables]];
    self.details.text = [[self.brain class] descriptionOfProgram:[self.brain program]];
    
}
- (IBAction)variablePressed:(UIButton*)sender {
    
    // Add current entered value to brain.
    if (self.entryInProgress)
        [self enterPressed];

    // Display variable, make entry, and update detail string.
    self.display.text = [sender currentTitle];
    [self.brain pushVariable:[sender currentTitle]];
    self.details.text = [[self.brain class] descriptionOfProgram:[self.brain program]];
    
}

- (IBAction)clearPressed {
    
    self.display.text = @"0";
    self.details.text = @"";
    self.entryInProgress = NO;
    [self.brain clear];
    
}

- (IBAction)undo {
    
    if (self.entryInProgress) {
        if (self.display.text.length == 1) {
            self.entryInProgress = NO;
            self.display.text = [NSString stringWithFormat:@"%f",
                                 [[self.brain class] runProgram:[self.brain program] usingVariableValues:self.variables]];
        } else {
            self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
        }
        
    } else {
        [self.brain undo];
        self.display.text = [NSString stringWithFormat:@"%f",
                             [[self.brain class] runProgram:[self.brain program] 
                                        usingVariableValues:self.variables]];
        self.details.text = [[self.brain class] descriptionOfProgram:[self.brain program]];

    }
    
}

- (void)viewDidUnload {
    [self setDetails:nil];
    [super viewDidUnload];
}
@end
