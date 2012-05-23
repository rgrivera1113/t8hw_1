//
//  Brain.h
//  rr_assignment_1
//
//  Created by Robert Rivera on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brain : NSObject

@property (nonatomic,readonly) id program;

- (void) pushOperand: (double) operand;
- (void) pushVariable: (NSString*) variable;
- (double) performOperation: (NSString*) operation;
- (double) performOperation:(NSString *)operation withVariables:(id)variables;
- (void) clear;
- (void) undo;

+ (double) popOperandOffProgramStack:(NSMutableArray*) stack;
+ (double) runProgram: (id) program;
+ (double) runProgram: (id) program usingVariableValues: (NSDictionary*) variables;
+ (NSSet*) variablesUsedInProgram: (id) program;
+ (NSString*) descriptionOfProgram:(id) program;
@end
