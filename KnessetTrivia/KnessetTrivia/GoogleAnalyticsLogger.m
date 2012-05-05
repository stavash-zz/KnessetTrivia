//
//  GoogleAnalyticsLogger.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoogleAnalyticsLogger.h"

#define kGAEventCategoryGameplay @"Gameplay"
#define kGAEventCateoryGeneral @"General"
#define kGAEventNameSecondsElapsed @"SecondsElapsed"
#define kGASiteNameOpenKnesset @"OpenKnesset"
#define kGASiteNamePublicKnowledge @"PublicKnowledge"
#define kGASecondsElapsedLabel @"SecondsElapsed"
#define kGAQuestionNameParty @"Party"
#define kGAQuestionNameAge   @"Age"

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
//    NSLog(@"GA LOGGING TIME %d",seconds);
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] sendGoogleAnalyticsTrackEventCategory:kGAEventCateoryGeneral withEventName:kGAEventNameSecondsElapsed andLabel:kGASecondsElapsedLabel withValue:seconds];
}

- (void) logSecondsToAnswerForImageTrivia:(int)seconds topLeft:(int)topLeftMemberId topRight:(int)topRightMemberId bottomLeft:(int)bottomLeftMemberId bottomRight:(int)bottomRightMemberId tries:(int)numOfTries {
    
    NSString *eventName = [NSString stringWithFormat:@"%d-%d-%d-%d-%d",topLeftMemberId,topRightMemberId,bottomLeftMemberId,bottomRightMemberId,numOfTries];
    
//    NSLog(@"GA LOGGING IMAGE %@ time:%d",eventName,seconds);
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] sendGoogleAnalyticsTrackEventCategory:kGAEventCategoryGameplay withEventName:eventName andLabel:kGASecondsElapsedLabel withValue:seconds]; 
}

- (void) logSecondsToAnswerForRightWrongTrivia:(int)seconds forMemberId:(int)memberId questionType:(RightWrongQuestionType)type isCorrect:(BOOL)correct{
    NSString *questionName;
    switch (type) {
        case kRightWrongQuestionTypeAge:
        {
            questionName = kGAQuestionNameAge;
        }
            break;
        case kRightWrongQuestionTypeParty:
        {
            questionName = kGAQuestionNameParty;
        }
        default:
            break;
    }
    
    NSString *correctness;
    if (correct) {
        correctness = @"Correct";
    } else {
        correctness = @"Wrong";
    }
    
    NSString *eventName = [NSString stringWithFormat:@"%d-%@-%@",memberId,questionName,correctness];
//    NSLog(@"GA LOGGING RIGHTWRONG %@ time:%d",eventName,seconds);
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] sendGoogleAnalyticsTrackEventCategory:kGAEventCategoryGameplay withEventName:eventName andLabel:kGASecondsElapsedLabel withValue:seconds];
}

- (void) logSiteLinkPressed:(SiteLinkType)type {
    NSString *eventName;
    switch (type) {
        case kSiteLinkOpenKnesset:
            eventName = kGASiteNameOpenKnesset;
            break;
        case kSiteLinkPublicKnowledge:
            eventName = kGASiteNamePublicKnowledge;
            break;
        default:
            break;
    }
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] sendGoogleAnalyticsTrackEventCategory:kGAEventCateoryGeneral withEventName:eventName];
}

@end
