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

@end

@implementation Brain

@synthesize programStack = _programStack;

- (NSMutableArray*) programStack {
    
    if (!_programStack)
        _programStack = [[NSMutableArray alloc] init];
    
    return _programStack;
}

- (void) pushOperand: (double) operand {
    
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    
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
  

- (void) clear {
    
    [self.programStack removeAllObjects];
    
}

- (id) program {
    
    return [self.programStack copy];
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
            if (divisor)
                result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([top isEqualToString:@"pi"]) {
            result = M_PI;
            [self popOperandOffProgramStack:stack];
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

+(double) runProgram:(id)program {
    
    NSMutableArray* stack;
    if ([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    
    return [self popOperandOffProgramStack:stack];
    
}
@end
