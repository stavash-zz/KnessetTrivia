//
//  GoogleAnalyticsLogger.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoogleAnalyticsLogger.h"
#import "DataManager.h"

#define kGAEventCateoryGeneral @"{general:''}"
#define kGAEventCategorySession @"{general:'session'}"
#define kGAEventCategoryMultipleChoice @"{gameplay:'idByName'}"
#define kGAEventCategoryParty @"{gameplay:'yesNoParty'}"
#define kGAEventCategoryAge @"{gameplay:'yesNoAge'}"
#define kGAEventCategoryRole @"{gameplay:'yesNoRole'}"
#define kGAEventCategoryPlaceOfBirth @"{gameplay:'yesNoBirthPlace'}"
#define kGALabelSiteOpenKnesset @"LinkToOpenKnesset"
#define kGALabelSitePublicKnowledge @"LinkToPublicKnowledge"

@implementation GoogleAnalyticsLogger

#pragma mark - Default

static GoogleAnalyticsLogger *sharedSingleton;

+ (GoogleAnalyticsLogger *)sharedLogger
{
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[GoogleAnalyticsLogger alloc] init];
        }
        return sharedSingleton;
    }
}

- (id)init {
	self = [super init];
	if (self != nil) {

	}
    
	return self;
}

+ (id) alloc {
	@synchronized(self)     {
		sharedSingleton = [super alloc];
		return sharedSingleton;
	}
	return nil;
}

#pragma mark - Public

- (void) logSecondsSpentInApplication:(int)seconds {
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] sendGoogleAnalyticsTrackEventCategory:kGAEventCategorySession withEventName:[NSString stringWithFormat:@"%d",seconds]];
}

- (void)logImageTriviaMembers:(NSArray *)memberIdsArr withAttempts:(NSArray *)attemptsArr forMember:(int)memberId andTime:(int)seconds {
    NSMutableString *attemptsJsonStr = [NSMutableString string];
    [attemptsJsonStr appendString:@"["];
    for (NSNumber *memberId in attemptsArr) {
        [attemptsJsonStr appendFormat:@"%d",[memberIdsArr indexOfObject:memberId]];
        if ([attemptsArr indexOfObject:memberId] != [attemptsArr count]-1) {
            [attemptsJsonStr appendString:@","];
        }
    }
    [attemptsJsonStr appendFormat:@"]"];
    
    NSMutableString *memberIdsJsonStr = [NSMutableString string];
    [memberIdsJsonStr appendString:@"["];
    for (NSNumber *memberId in memberIdsArr) {
        [memberIdsJsonStr appendFormat:@"'%d'",[memberId intValue]];
        if ([memberIdsArr indexOfObject:memberId] != [memberIdsArr count]-1) {
            [memberIdsJsonStr appendString:@","];
        }
    }
    [memberIdsJsonStr appendString:@"]"];
    
    NSString *eventLabel = [NSString stringWithFormat:@"{o:%@, g:%@, t:'%d'}",memberIdsJsonStr,attemptsJsonStr,seconds];
    NSString *eventName = [NSString stringWithFormat:@"{mid:%d}",memberId];
    
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] sendGoogleAnalyticsTrackEventCategory:kGAEventCategoryMultipleChoice withEventName:eventName andLabel:eventLabel withValue:0];
}

- (void)logRightWrongAnswerForMember:(int)memberId ofQuestionType:(RightWrongQuestionType)type userGuess:(BOOL)guess isCorrect:(BOOL)correct answerDisplayed:(NSObject *)answer timeToAnswer:(int)seconds {
    NSString *category = nil;
    switch (type) {
        case kRightWrongQuestionTypeAge:
        {
            category = kGAEventCategoryAge;
        }
            break;
        case kRightWrongQuestionTypeParty:
        {
            category = kGAEventCategoryParty;
        }
            break;
        case kRightWrongQuestionTypePlaceOfBirth:
        {
            category = kGAEventCategoryPlaceOfBirth;
        }
            break;
        case kRightWrongQuestionTypeRole:
        {
            category = kGAEventCategoryRole;
        }
            break;
        default:
            break;
    }
    
    NSString *correctness = nil;
    if (correct) {
        correctness = @"yes";
    } else {
        correctness = @"no";
    }
    
    NSString *guessStr = nil;
    if (guess) {
        guessStr = @"yes";
    } else {
        guessStr = @"no";
    }

    NSString *answerStr = nil;
    if ([answer isKindOfClass:[NSString class]]) {
        answerStr = [NSString stringWithString:(NSString *)answer];
    } else if ([answer isKindOfClass:[NSNumber class]]) {
        answerStr = [NSString stringWithFormat:@"%d",[(NSNumber *)answer intValue]];
    }
    
    if (type == kRightWrongQuestionTypeParty) { //patch for translating party name to party id
        answerStr = [NSString stringWithFormat:@"%d",[[DataManager sharedManager] getPartyIdForName:answerStr]];
    }
    
    NSString *eventLabel = [NSString stringWithFormat:@"{q:'%@' a:'%@' g:'%@' t:'%d'}",answer,correctness,guessStr,seconds];
    
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] sendGoogleAnalyticsTrackEventCategory:category withEventName:[NSString stringWithFormat:@"{mid:%d}",memberId] andLabel:eventLabel withValue:seconds];
}

- (void) logSiteLinkPressed:(SiteLinkType)type {
    NSString *eventName;
    switch (type) {
        case kSiteLinkOpenKnesset:
            eventName = kGALabelSiteOpenKnesset;
            break;
        case kSiteLinkPublicKnowledge:
            eventName = kGALabelSitePublicKnowledge;
            break;
        default:
            break;
    }
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] sendGoogleAnalyticsTrackEventCategory:kGAEventCateoryGeneral withEventName:eventName];
}

@end
