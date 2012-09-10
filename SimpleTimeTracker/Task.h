//
//  Task.h
//  SimpleTimeTracker
//
//  Created by Matthew Baranowski on 5/24/12.
//  Copyright (c) 2012 Studio MFB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaskWorkInterval;

@interface Task : NSManagedObject
{
}

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * totalElapsed;
@property (nonatomic) BOOL active;
@property (nonatomic, retain) NSDate * timeLastStarted;
@property (nonatomic, retain) NSSet *intervals;

-(unsigned int)elapsedTime;
-(NSString*)formattedElapsedTime;

+(NSString*)formatSeconds:(unsigned int)seconds;
+(NSDateFormatter*)dateFormatter;


@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addIntervalsObject:(TaskWorkInterval *)value;
- (void)removeIntervalsObject:(TaskWorkInterval *)value;
- (void)addIntervals:(NSSet *)values;
- (void)removeIntervals:(NSSet *)values;
- (void)toggleActive;

@end
