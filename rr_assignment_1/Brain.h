//
//  Brain.h
//  rr_assignment_1
//
//  Created by Robert Rivera on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brain : NSObject

- (void) pushOperand: (double) operand;
- (double) performOperation: (NSString*) operation;
- (void) clear;


@end
