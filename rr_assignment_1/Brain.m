//
//  Brain.m
//  rr_assignment_1
//
//  Created by Robert Rivera on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Brain.h"

@interface Brain() 

@property (nonatomic,strong) NSMutableArray *operandStack;

@end

@implementation Brain

@synthesize operandStack = _operandStack;

- (NSMutableArray*) operandStack {
    
    if (!_operandStack)
        _operandStack = [[NSMutableArray alloc] init];
    
    return _operandStack;
}

- (void) pushOperand: (double) operand {
    
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
    
}

- (double) popOperand {
    
    NSNumber *operand = [self.operandStack lastObject];
    
    if (operand)
        [self.operandStack removeLastObject];
    
    return [operand doubleValue];

}

- (double) performOperation: (NSString*) operation {
    
    double result = 0.0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor)
            result = [self popOperand] / divisor;
    } else if ([operation isEqualToString:@"pi"]) {
        result = M_PI;
    } else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]) {
        result = sqrt([self popOperand]);
    }
    
    [self pushOperand:result];
    
    return result;
}

- (void) clear {
    
    [self.operandStack removeAllObjects];
    
}

@end
