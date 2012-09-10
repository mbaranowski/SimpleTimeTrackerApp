//
//  TaskDetailCell.h
//  SimpleTimeTracker
//
//  Created by Matthew Baranowski on 5/23/12.
//  Copyright (c) 2012 Studio MFB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDetailCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* title;
@property (nonatomic, weak) IBOutlet UILabel* started;
@property (nonatomic, weak) IBOutlet UILabel* elapsed;
@property (nonatomic, weak) IBOutlet UITextView* notes;

@property (nonatomic, weak) IBOutlet UIButton* actionButton;

@end
