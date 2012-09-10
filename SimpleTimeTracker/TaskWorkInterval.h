//
//  TaskWorkInterval.h
//  SimpleTimeTracker
//
//  Created by Matthew Baranowski on 5/24/12.
//  Copyright (c) 2012 Studio MFB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface TaskWorkInterval : NSManagedObject

@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) Task *task;

@end
