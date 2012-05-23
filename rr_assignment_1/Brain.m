//
//  Brain.m
//  rr_assignment_1
//
//  Created by Robert Rivera on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Brain.h"

@interface Brain() 

@property (nonatomic,strong) NSMutableArray *programStack;
@property (nonatomic,strong) NSSet *doubleOperandSet, 
                                    *singleOperandSet, 
                                    *noOperandSet;

@end

@implementation Brain

@synthesize programStack = _programStack;
@synthesize doubleOperandSet = _doubleOperandSet;
@synthesize singleOperandSet = _singleOperandSet;
@synthesize noOperandSet = _noOperandSet;

- (NSMutableArray*) programStack {
    
    if (!_programStack)
        _programStack = [[NSMutableArray alloc] init];
    
    return _programStack;
}

+ (BOOL) doubleOperationSet: (NSString*) operation {
    NSSet* doubleOperations = [[NSSet alloc] initWithObjects:@"+",@"-",@"*",@"/", nil];
    return [doubleOperations containsObject:operation];
}

+ (BOOL) singleOperationSet: (NSString*) operation {
    NSSet* singleOperations = [[NSSet alloc] initWithObjects:@"sin",@"cos",@"sqrt", nil];
    return [singleOperations containsObject:operation];
}

+ (BOOL) noOperationsSet: (NSString*) operation {
    NSSet* noOperations = [[NSSet alloc] initWithObjects:@"pi", nil];
    return [noOperations containsObject:operation];
}

- (void) pushOperand: (double) operand {
    
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    
}

- (void) pushVariable:(NSString *)variable {
    
    [self.programStack addObject:variable];
}

- (double) popOperand {
    
    NSNumber *operand = [self.programStack lastObject];
    
    if (operand)
        [self.programStack removeLastObject];
    
    return [operand doubleValue];

}

- (double) performOperation: (NSString*) operation {
 
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

- (double) performOperation:(NSString *)operation withVariables:(id)variables {
    
    [self.programStack addObject:operation];
    if ([variables isKindOfClass:[NSDictionary class]])
        return [[self class] runProgram:self.program usingVariableValues:variables];
    else
        return [[self class] runProgram:self.program];

    
}

- (void) clear {
    
    [self.programStack removeAllObjects];
    
}

- (void) undo {
    
    [self.programStack removeLastObject];
    
}

- (id) program {
    
    return [self.programStack copy];
}

+ (BOOL) isOperation: (NSString*) operation {
    
    // Should have a plist holding constant values for operations.
    NSSet* variables = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/",
                        @"cos", @"sin", @"sqrt", @"pi", nil];
    
    return [variables containsObject:operation];
    
}

+ (double) popOperandOffProgramStack:(NSMutableArray *)stack {
    
    double result = 0.0;
    id top = [stack lastObject];
    
    if (top)
        [stack removeLastObject];
    
    if ([top isKindOfClass:[NSNumber class]])
        result = [top doubleValue];
    else if ([top isKindOfClass:[NSString class]]) {
           
        if ([top isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([top isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([top isEqualToString:@"*"]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([top isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            // Avoid a div/0 error
            if (divisor)
                result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([top isEqualToString:@"pi"]) {
            result = M_PI;
        } else if ([top isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([top isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([top isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        }
    }
    
    return result;
}

+ (NSString*) describeOperand:(NSMutableArray*) stack {
    
    NSString* result = @"";
    id top = [stack lastObject];
    
    if (top)
        [stack removeLastObject];
    
    if ([top isKindOfClass:[NSNumber class]]) {
        result = [result stringByAppendingFormat:@"%@",[top stringValue]];
    } else if ([top isKindOfClass:[NSString class]]) {
        
        if ([self noOperationsSet:top])
            result = [result stringByAppendingFormat:@"%@", top];
        else if([self singleOperationSet:top]) {
            result = [result stringByAppendingFormat:@"%@(%@) ",top,[self describeOperand:stack]];
        } else if ([self doubleOperationSet:top]) {
            NSString* right = [self describeOperand:stack];
            result = [result stringByAppendingFormat:@"(%@ %@ %@) ", [self describeOperand:stack], top, right];
        } else {
            result = [result stringByAppendingFormat:@"%@", top];
        }
    }
    
    return result;

}

+(double) runProgram:(id)program {
    
    NSMutableArray* stack;
    if ([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    
    return [self popOperandOffProgramStack:stack];
    
}

+ (double) runProgram: (id) program usingVariableValues: (NSDictionary*) variables {
    
    // Create a mutable copy of the program stack.
    NSMutableArray* stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        
        // Traverse the copy to assign values to the variables.
        // For convenience, set up an array of keys as a set for comparison.
        NSSet* variableNames = [[NSSet alloc] initWithArray:[variables allKeys]];
        for (int index = 0; index < stack.count; index++) {
            
            id item = [stack objectAtIndex:index];
            if ([variableNames containsObject:item]) {
                [stack replaceObjectAtIndex:index 
                                 withObject:[variables valueForKey:item]];
            }
            
        }
    }
    
    return [self popOperandOffProgramStack:stack];
    
}

+ (NSSet*) variablesUsedInProgram: (id) program {
    
    NSMutableSet* variables;
    if ([program isKindOfClass:[NSArray class]]) {
        
        variables = [[NSMutableSet alloc] init];
        for (id item in program) {
            if ([item isKindOfClass:[NSString class]]) {
                if (![[self class] isOperation: item])
                    [variables addObject:item];
            }
            
        }
        
    }
    
    return [variables copy];
    
}

+ (NSString*) descriptionOfProgram:(id)program {
    
    NSMutableArray* stack;
    NSString* result = @"";
    if ([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    
    // The description method only returns a string for a complete
    // set of operands and operations.  Traverse the entire
    // stack to ensure all values are consumed.
    while (stack.count > 0) {
        result = [result stringByAppendingFormat:@"%@",[self describeOperand:stack]];
        if (stack.count > 0)
            result = [result stringByAppendingString:@", "];
    }
    
    return result;
}



@end
