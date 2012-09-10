//
//  TaskWorkIntervalCell.h
//  SimpleTimeTracker
//
//  Created by Matthew Baranowski on 5/23/12.
//  Copyright (c) 2012 Studio MFB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskWorkIntervalCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* started;
@property (nonatomic, weak) IBOutlet UILabel* elapsed;
@property (nonatomic, weak) IBOutlet UILabel* ended;

@end
