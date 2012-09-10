//
//  TaskCell.m
//  SimpleTimeTracker
//
//  Created by Matthew Baranowski on 5/23/12.
//  Copyright (c) 2012 Studio MFB. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell
@synthesize title;
@synthesize elapsed;
@synthesize actionButton;
@synthesize task;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionButtonPressed:(id)sender
{
    NSLog(@"action button pressed!");
}

-(void)updateElapsedLabel:(id)sender
{
    self.elapsed.text = [task formattedElapsedTime];
}


@end
