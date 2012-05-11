//
//  GoogleAnalyticsLogger.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoogleAnalyticsLogger.h"

#define kGAEventCateoryGeneral @"General"
#define kGAEventCategorySession @"Gameplay-Session"
#define kGAEventCategoryMultipleChoice @"Gameplay-MultipleChoice"
#define kGAEventCategoryParty @"Gameplay-Party"
#define kGAEventCategoryAge @"Gameplay-Age"
#define kGAEventCategoryRole @"Gameplay-Role"
#define kGAEventCategoryPlaceOfBirth @"Gameplay-PlaceOfBirth"
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
    NSLog(@"GA LOGGING TIME SPENT IN APP %d",seconds);
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] sendGoogleAnalyticsTrackEventCategory:kGAEventCategorySession withEventName:[NSString stringWithFormat:@"%d",seconds]];
}

- (void)logImageTriviaChoices:(NSArray *)wrongChoicesArray forMember:(int)memberId otherMembersDisplayed:(NSArray *)membersArray andTime:(int)seconds{
    NSMutableString *eventStr = [NSMutableString string];
    if (wrongChoicesArray) {
        for (NSNumber *memberId in wrongChoicesArray) {
            [eventStr appendFormat:@"%d-",[memberId intValue]];
        }
    }
    [eventStr appendFormat:@"#"];
    if (membersArray) {
        for (NSNumber *memberIdNum in membersArray) {
            if ([memberIdNum intValue]!=memberId) {
                [eventStr appendFormat:@"-%d",[memberIdNum intValue]];
            }
        }
    }
//    NSLog(@"GA LOGGING IMAGE QUESTION FOR MEMBER %d: %@",memberId,eventStr);
    
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] sendGoogleAnalyticsTrackEventCategory:kGAEventCategoryMultipleChoice withEventName:[NSString stringWithFormat:@"%d",memberId] andLabel:eventStr withValue:seconds];
}

- (void)logRightWrongAnswerForMember:(int)memberId ofQuestionType:(RightWrongQuestionType)type isCorrect:(BOOL)correct answerDisplayed:(NSObject *)answer timeToAnswer:(int)seconds{
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
    
    NSString *correctness;
    if (correct) {
        correctness = @"Correct";
    } else {
        correctness = @"Wrong";
    }

    NSString *answerStr = nil;
    if ([answer isKindOfClass:[NSString class]]) {
        answerStr = [NSString stringWithString:(NSString *)answer];
    } else if ([answer isKindOfClass:[NSNumber class]]) {
        answerStr = [NSString stringWithFormat:@"%d",[(NSNumber *)answer intValue]];
    }
    
    NSString *eventStr = [NSString stringWithFormat:@"%@-%@",answerStr,correctness];
    
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] sendGoogleAnalyticsTrackEventCategory:category withEventName:[NSString stringWithFormat:@"%d",memberId] andLabel:eventStr withValue:seconds];
    
    NSLog(@"LOGGING %@ QUESTION FOR MEMBER %d: %@",category,memberId,eventStr);
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
