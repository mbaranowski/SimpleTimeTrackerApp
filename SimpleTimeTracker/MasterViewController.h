//
//  MasterViewController.h
//  SimpleTimeTracker
//
//  Created by Matthew Baranowski on 5/23/12.
//  Copyright (c) 2012 Studio MFB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCell.h"
#import "TaskWorkInterval.h"

@class DetailViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>
{
    TaskCell* activeCell;
    NSTimer* _updateTimer;
}

@property (nonatomic, retain) NSTimer* updateTimer;
@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
