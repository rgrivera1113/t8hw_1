//
//  ViewController.h
//  rr_assignment_1
//
//  Created by Robert Rivera on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatingViewController.h"

@interface ViewController : RotatingViewController <UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *details;



@end
