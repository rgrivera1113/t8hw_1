//
//  GraphVC.h
//  rr_assignment_1
//
//  Created by Robert Rivera on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brain.h"
#import "SplitViewPresenter.h"

@interface GraphVC : UIViewController <SplitViewPresenter>

@property (nonatomic,strong) NSArray* program; 

@end
