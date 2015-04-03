//
//  DataManager.m
//  
//
//  Created by Michael Shin on 2/10/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "DataManager.h"
#import "Purifier.h"
//#import "PurifierState.h"
//#import "Schedule.h"
//#import "Account.h"
//#import <Parse/Parse.h>

#define kPubNubHistoryMessageLimit 5
#define kPubNubMessagePurifierState 100

@interface DataManager()
@property (nonatomic, strong) NSMutableArray *purifierArray;
@property (nonatomic, strong) NSMutableDictionary *purifierStateDict;
@end

@implementation DataManager

static DataManager *sharedInstance = nil;

+ (DataManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if(self) {
        //[PubNub setDelegate:self];
        _purifierArray = [[NSMutableArray alloc] init];
        _purifierStateDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (NSArray *)getAllPurifiers
{
    return _purifierArray;
}
/*
- (void)fetchAllPurifiers
{
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *purifierRelation = [currentUser relationForKey:@"Purifiers"];
    PFQuery *query = [purifierRelation query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            for(Purifier *purifier in objects) {
                [_purifierArray addObject:purifier];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerPurifiersLoaded object:nil];
            [self subscribeOnAllChannels];
        }
    }];
}

- (void)fetchScheduleForPurifier:(Purifier *)purifier withBlock:(PFArrayResultBlock)block
{
    PFRelation *scheduleRelation = [purifier scheduleRelation];
    PFQuery *query = [scheduleRelation query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            NSMutableArray *scheduleArray = [[NSMutableArray alloc] init];
            for(Schedule *schedule in objects) {
                [scheduleArray addObject:schedule];
            }
            block(scheduleArray, nil);
        }
        else {
            block(nil, error);
        }
    }];
}

- (void)subscribeOnAllChannels
{
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:kPubNubPublishKey
                                                                     subscribeKey:kPubNubSubscribeKey
                                                                        secretKey:kPubNubSecretKey];
    [PubNub setConfiguration:configuration];
    [PubNub connect];
    [PNLogger loggerEnabled:NO];
    
    NSMutableArray *channelArray = [[NSMutableArray alloc] init];
    
    for(Purifier *device in _purifierArray) {
        PNChannel *channel = [PNChannel channelWithName:device.Channel shouldObservePresence:YES];
        [channelArray addObject:channel];
        
        [self fetchLatestPurifierStateFromChannel:device.Channel withCompletionBlock:^(PurifierState *state, PNError *error) {
            //
        }];
    }
    
    [PubNub subscribeOn:channelArray];
}

- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message
{
    NSLog(@"%@", [NSString stringWithFormat:@"received: %@", message.message] );
    
    if([self isPurifierStateMessage:message]) {
        [self handlePurifierStateMessage:message];
    }
}

- (void)pubnubClient:(PubNub *)client didSubscribeOn:(NSArray *)channelObjects
{
    
}

- (void)pubnubClient:(PubNub *)client subscriptionDidFailWithError:(PNError *)error
{
    
}

- (BOOL)isPurifierStateMessage:(PNMessage *)message
{
    return ([message.message[@"id"] integerValue] == kPubNubMessagePurifierState);
}

- (void)fetchLatestPurifierStateFromChannel:(NSString *)channel withCompletionBlock:(PurifierStateResultBlock)block
{
    PNChannel *pubNubChannel = [PNChannel channelWithName:channel shouldObservePresence:YES];
    
    [PubNub requestHistoryForChannel:pubNubChannel
                                from:nil
                               limit:kPubNubHistoryMessageLimit
                 withCompletionBlock:^(NSArray *messages, PNChannel *channel, PNDate *startDate, PNDate *endDate, PNError *error) {
                     if(!error) {
                         for(PNMessage *message in messages) {
                             if([self isPurifierStateMessage:message]) {
                                 [self handlePurifierStateMessage:message];
                                 return;
                             }
                         }
                         block(nil, nil); //Purifier state message not found in history
                     }
                     else {
                         block(nil, error);
                     }
                 }];
}

- (void)publishPurifierState:(PurifierState *)state
{
    [PubNub sendMessage:[state dictionary] toChannel:state.channel];
}

+ (BOOL)isPurifierStateMessage:(PNMessage *)message
{
    return [message.message[@"id"] integerValue] == kPubNubMessagePurifierState;
}

- (void)handlePurifierStateMessage:(PNMessage *)message
{
    PurifierState *state = [[PurifierState alloc] initWithMessage:message];
    [_purifierStateDict setObject:state forKey:message.channel.name];
    NSLog(@"Here: %@", [state dictionary]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerPurifierStateChanged object:nil];
}

- (PurifierState *)getPurifierStateForChannel:(NSString *)channel
{
    return [[_purifierStateDict objectForKey:channel] copy];
}

- (void)addSchedule:(Schedule *)schedule withBlock:(PFBooleanResultBlock)block
{
    [schedule saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            [schedule.Purifier addSchedule:schedule];
            [schedule.Purifier saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!succeeded) {
                    [schedule.Purifier removeSchedule:schedule];
                }
                block(succeeded, error);
            }];
        }
        else {
            block(NO, error);
        }
    }];
}

- (void)logOutAndClearData
{
    [Account logOut];
    
    [_purifierArray removeAllObjects];
    [_purifierStateDict removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoginStateChanged object:nil];
}
 */

@end
