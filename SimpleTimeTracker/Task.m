//
//  Task.m
//  SimpleTimeTracker
//
//  Created by Matthew Baranowski on 5/24/12.
//  Copyright (c) 2012 Studio MFB. All rights reserved.
//

#import "Task.h"
#import "TaskWorkInterval.h"


@implementation Task

@dynamic timeStamp;
@dynamic title;
@dynamic notes;
@dynamic totalElapsed;
@dynamic active;
@dynamic timeLastStarted;
@dynamic intervals;

static NSDateFormatter* sDateFormatter;

+(NSDateFormatter*)dateFormatter
{
    if (sDateFormatter == nil) {
        sDateFormatter = [[NSDateFormatter alloc] init];
        [sDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [sDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return sDateFormatter;
}

-(unsigned int)elapsedTime
{
    unsigned int totalSeconds = [self.totalElapsed unsignedIntegerValue];
    if (self.active) {
        NSDate* timeLS = self.timeLastStarted;
        double interval = -round([timeLS timeIntervalSinceNow]);
        totalSeconds += (unsigned int)interval;
    }
    return totalSeconds;
}

+(NSString*)formatSeconds:(unsigned int)num
{
    if (num > 3600) {
        int hr = num / 3600; 
        num = num - (hr * 3600);
        int min = num / 60;
        int sec = num - (min * 60);
        return [NSString stringWithFormat:@"%dhr %dmin %dsec", hr, min, sec];
    } else if (num > 60) {
        int min = num / 60;
        int sec = num - (min * 60);
        return [NSString stringWithFormat:@"%dmin %dsec", min, sec];
    } else {
        return [NSString stringWithFormat:@"%dsec", num];
    }
}
-(NSString*)formattedElapsedTime
{
    unsigned int num = [self elapsedTime];
    return [Task formatSeconds:num]; 
}

-(void)toggleActive
{
    self.active = !self.active;
    if (self.active)
    {
        self.timeLastStarted = [NSDate date];
    }
    else
    {
        unsigned int duration = -round([self.timeLastStarted timeIntervalSinceNow]);
        unsigned int totalElapsed = [self.totalElapsed unsignedIntegerValue];
        self.totalElapsed = [NSNumber numberWithUnsignedInteger:(duration + totalElapsed)];
        [self addNewIntervalForTask];
    }
    
    [self saveContext];
}

-(void)saveContext
{
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (void)addNewIntervalForTask
{
    TaskWorkInterval *interval = [NSEntityDescription insertNewObjectForEntityForName:@"TaskWorkInterval" inManagedObjectContext:self.managedObjectContext];
    
    interval.task = self;
    interval.start = self.timeLastStarted;
    interval.end = [NSDate date];
    
    [self addIntervalsObject: interval];
    
    NSLog(@"addNewIntervalForTask intervals:%d", [self.intervals count]);
}

@end
