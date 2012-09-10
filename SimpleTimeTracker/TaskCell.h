//
//  TaskCell.h
//  SimpleTimeTracker
//
//  Created by Matthew Baranowski on 5/23/12.
//  Copyright (c) 2012 Studio MFB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskCell : UITableViewCell
{
    Task* _task;
}

@property (nonatomic, retain) Task* task;

@property (nonatomic, weak) IBOutlet UILabel* title;
@property (nonatomic, weak) IBOutlet UILabel* elapsed;
@property (nonatomic, weak) IBOutlet UIButton* actionButton;

-(void)updateElapsedLabel:(id)sender;

@end
