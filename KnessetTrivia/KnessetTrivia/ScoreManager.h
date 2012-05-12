//
//  ScoreManager.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/2/12.
//   
//

#import <Foundation/Foundation.h>

#define kScoreManagerNotificationScoreUpdated @"scoreUpdatedNotification"
#define kScoreManagerNotificationHighscoreUpdated @"highScoreUpdatedNotification"

@interface ScoreManager : NSObject {
    int highScore;
    int score;
}

+ (ScoreManager *) sharedManager;

- (void)resetScore;
- (void)updateCorrectAnswer;
- (void)updateWrongAnswer;
- (void)updateHelpRequested;
- (int) getCurrentScoreAboveZero;
- (NSString *) getCurrentScoreStr;
- (void) challengeHighScore;
- (int)getHighScore;
- (BOOL)isCurrentScorePositive;
@end
