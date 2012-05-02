//
//  ScoreManager.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@end
