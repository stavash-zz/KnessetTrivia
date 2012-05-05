//
//  ScoreManager.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/2/12.
//   
//

#import "ScoreManager.h"

#define kScoreManagerScoreForCorrectImageAnswer 9
#define kScoreManagerPenaltyForWrongImageAnswer 10
#define kScoreManaferPenaltyForHelp 5

@implementation ScoreManager

static ScoreManager *manager = nil;

#pragma mark - Default

+ (ScoreManager *) sharedManager {
	@synchronized(self) {
		if (!manager) {
			[[ScoreManager alloc] init];
		}
		return manager;
	}
	return nil;
}

+ (id) alloc {
	@synchronized(self)     {
		manager = [super alloc];
		return manager;
	}
	return nil;
}

- (id) init {
    self=[super init];
	if(self) {
        NSNumber *highScoreNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"];
        if (!highScoreNum) {
            highScoreNum = [NSNumber numberWithInt:0];
            [self challengeHighScore];
        }
        highScore = [highScoreNum intValue];
        [self updateHighScoreChange];
        score = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scoreUpdatedNotification" object:nil];
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - Score

- (void)resetScore {
    score = 0;
}

- (void)updateScoreChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scoreUpdatedNotification" object:nil];
}

- (void)updateCorrectAnswer {
    score += kScoreManagerScoreForCorrectImageAnswer;
    [self updateScoreChange];
}

- (void) updateWrongAnswer {
    score -= kScoreManagerPenaltyForWrongImageAnswer;
    [self updateScoreChange];
}

- (void)updateHelpRequested {
    score -= kScoreManaferPenaltyForHelp;
    [self updateScoreChange];
}

- (int) getCurrentScoreAboveZero {
    if (score < 0) return 0;
    else return score;
}

- (NSString *) getCurrentScoreStr {
    if (score < 0) {
        return [NSString stringWithFormat:@"%d-",abs(score)];
    } else {
        return [NSString stringWithFormat:@"%d",score];
    }
}

#pragma mark - High Score

- (void) updateHighScoreChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"highScoreUpdatedNotification" object:nil];
}

- (void) challengeHighScore {
    if (highScore < score) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:score] forKey:@"highScore"];
        highScore = score;
        [self updateHighScoreChange];
    }
}

- (int)getHighScore {
    return highScore;
}

@end
