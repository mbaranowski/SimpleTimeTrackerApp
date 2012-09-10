//
//  DetailViewController.h
//  SimpleTimeTracker
//
//  Created by Matthew Baranowski on 5/23/12.
//  Copyright (c) 2012 Studio MFB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "TaskDetailCell.h"
#import "TaskWorkIntervalCell.h"

@interface DetailViewController : UITableViewController <UISplitViewControllerDelegate, UITextViewDelegate>
{
    NSArray* _taskIntervals;
    UIView* _accessoryView;
    UITextView* _notesTextView;
    NSTimer* _updateTimer;
    TaskDetailCell* _taskDetailCell;
}

@property (nonatomic, retain) TaskDetailCell* taskDetailCell;
@property (nonatomic, retain) NSTimer* updateTimer;
@property (nonatomic, retain) NSArray* taskIntervals;
@property (strong, nonatomic) Task* detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, assign) IBOutlet UIView *accessoryView;
@property (nonatomic, assign) UITextView* notesTextView;

- (IBAction)keyboardDone:(id)sender;


- (void)textViewDidChange:(UITextView *)textView;

@end
