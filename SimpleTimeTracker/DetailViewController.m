//
//  DetailViewController.m
//  SimpleTimeTracker
//
//  Created by Matthew Baranowski on 5/23/12.
//  Copyright (c) 2012 Studio MFB. All rights reserved.
//

#import "DetailViewController.h"
#import "Task.h"
#import "TaskWorkInterval.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize taskIntervals;
@synthesize accessoryView;
@synthesize notesTextView;
@synthesize updateTimer;
@synthesize taskDetailCell;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self updateSortedIntervals];
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimerTick:) userInfo:nil repeats:YES];

    [self configureView];
}

-(void)updateSortedIntervals
{
    self.taskIntervals = [self.detailItem.intervals sortedArrayUsingDescriptors: @[[[NSSortDescriptor alloc] initWithKey:@"end" ascending:NO]] ];
}

- (void)updateTimerTick:(id)sender
{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ] withRowAnimation:UITableViewRowAnimationNone ];
    [self.tableView endUpdates];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self.updateTimer invalidate];
    self.updateTimer = nil;
    
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 1;
    else {
        return [self.taskIntervals count];
    };
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Work Intervals";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath indexAtPosition:0] == 1) { return 46.0f; }
    else  { 
        // calculate size based on notes text view
        return 221.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath indexAtPosition:0] == 0)
    {
        return [self configureTaskDetailCell];
    }
    else
    {
        TaskWorkIntervalCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TaskIntervalCell"];
        TaskWorkInterval* interval = [self.taskIntervals objectAtIndex:[indexPath indexAtPosition:1]];
        cell.started.text = [[Task dateFormatter] stringFromDate:interval.start];
        cell.ended.text = [[Task dateFormatter] stringFromDate:interval.end];
        unsigned int elapsedSeconds = (unsigned int)[interval.end timeIntervalSinceDate:interval.start];
        cell.elapsed.text = [Task formatSeconds: elapsedSeconds];
        return cell;
    }
}

- (TaskDetailCell*)configureTaskDetailCell
{
    self.taskDetailCell = nil;
    TaskDetailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TaskDetailCell"];
    self.taskDetailCell = cell;

    Task* task = (Task*)self.detailItem;
    cell.title.text = task.title;
    cell.started.text = [[Task dateFormatter] stringFromDate:task.timeStamp];
    cell.elapsed.text = [task formattedElapsedTime];
    self.notesTextView = cell.notes;
    cell.notes.text = task.notes;
    cell.notes.delegate = self;
    [cell.actionButton addTarget:self action:@selector(taskActionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* backgroundImage = task.active ? @"TaskCellSelected.png" : @"TaskCellDefault.png";
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:backgroundImage] stretchableImageWithLeftCapWidth:0.0   topCapHeight:5.0] ];
    cell.elapsed.textColor = task.active ? [UIColor blueColor] : [UIColor grayColor];
    NSString* imageName = task.active ? @"Pause.png" : @"Play.png";
    [cell.actionButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    return cell;
}


#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)notes
{
    self.detailItem.notes = notes.text;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView 
{    
    if (aTextView.inputAccessoryView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"KeyboardAccessoryView" owner:self options:nil];
        // Loading the AccessoryView nib file sets the accessoryView outlet.
        aTextView.inputAccessoryView = accessoryView;    
        // After setting the accessory view for the text view, we no longer need a reference to the accessory view.
        self.accessoryView = nil;
    }
    
    return YES;
}

- (IBAction)keyboardDone:(id)sender;
{
    [self.notesTextView resignFirstResponder];
}

#pragma mark -

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.detailViewController.detailItem = object;
    }
     */
}

- (void)taskActionButton:(id)sender
{
    TaskDetailCell* customCell = (TaskDetailCell*)[[sender superview] superview];

    [self.detailItem toggleActive];
    
    if ([self.detailItem.intervals count] != [self.taskIntervals count]) {
        [self updateSortedIntervals];
    }
    
    NSString* imageName = self.detailItem.active  ? @"Pause.png" : @"Play.png";
    [customCell.actionButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

    if (!self.detailItem.active)
    {
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:1] ] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }    
}


@end
