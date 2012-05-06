//
//  GoogleAnalyticsLogger.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
- (void) logSecondsToAnswerForImageTrivia:(int)seconds topLeft:(int)topLeftMemberId topRight:(int)topRightMemberId bottomLeft:(int)bottomLeftMemberId bottomRight:(int)bottomRightMemberId correctMemberId:(int)correctId tries:(int)numOfTries;
- (void) logSecondsToAnswerForRightWrongTrivia:(int)seconds forMemberId:(int)memberId questionType:(RightWrongQuestionType)type isCorrect:(BOOL)correct;
- (void) logSiteLinkPressed:(SiteLinkType)type;

@end
