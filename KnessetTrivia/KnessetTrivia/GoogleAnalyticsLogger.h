//
//  GoogleAnalyticsLogger.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/5/12.
//

#import <Foundation/Foundation.h>
#import "GoogleAnalyticsManager.h"
#import "RightWrongTriviaViewController.h"

typedef enum {
    kSiteLinkOpenKnesset,
    kSiteLinkPublicKnowledge
}SiteLinkType;

@interface GoogleAnalyticsLogger : NSObject

+ (GoogleAnalyticsLogger *)sharedLogger;

- (void) logSecondsSpentInApplication:(int)seconds;
- (void)logImageTriviaMembers:(NSArray *)memberIdsArr withAttempts:(NSArray *)attemptsArr forMember:(int)memberId andTime:(int)seconds ;
- (void)logRightWrongAnswerForMember:(int)memberId ofQuestionType:(RightWrongQuestionType)type userGuess:(BOOL)guess isCorrect:(BOOL)correct answerDisplayed:(NSObject *)answer timeToAnswer:(int)seconds;
- (void) logSiteLinkPressed:(SiteLinkType)type;

@end
