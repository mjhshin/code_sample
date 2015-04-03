//
//  DataManager.h
//  
//
//  Created by Michael Shin on 2/10/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Parse/Parse.h>

@class Purifier;
@class PurifierState;
//@class Schedule;

#define kDataManagerLoginStateChanged       @"kDataManagerLoginStateChanged"
#define kDataManagerPurifiersLoaded         @"kDataManagerPurifiersLoaded"
#define kDataManagerPurifierStateChanged    @"kDataManagerPurifierStateChanged"

typedef void (^PurifierStateResultBlock)(PurifierState *state);

@interface DataManager : NSObject

+ (DataManager *)sharedInstance;

- (void)subscribeOnAllChannels;

- (NSArray *)getAllPurifiers;
- (PurifierState *)getPurifierStateForChannel:(NSString *)channel;

- (void)fetchAllPurifiers;
//- (void)fetchScheduleForPurifier:(Purifier *)purifier withBlock:(PFArrayResultBlock)block;
//- (void)fetchLatestPurifierStateFromChannel:(NSString *)channel withCompletionBlock:(PurifierStateResultBlock)block;

- (void)publishPurifierState:(PurifierState *)state;

//- (void)addSchedule:(Schedule *)schedule withBlock:(PFBooleanResultBlock)block;

- (void)logOutAndClearData;

@end
