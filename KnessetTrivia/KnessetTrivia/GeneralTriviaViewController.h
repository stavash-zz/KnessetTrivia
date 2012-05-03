//
//  GeneralTriviaViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralTriviaDelegateProtocol.h"
#import "GameFlowDelegateProtocol.h"

@class NewGameViewController, EndOfGameViewController;

typedef enum{
    kTriviaTypeImage,
    kTriviaTypeRightWrong,
    triviaTypeCount
}TriviaType;

@interface GeneralTriviaViewController : UIViewController <GameFlowDelegate,GeneralTriviaDelegate>{
    UILabel *scoreLabel;
    UIProgressView *timeProgressView;
    NSTimer *timer;
    float remainingSeconds;
    EndOfGameViewController *endOfGameVC;
    NewGameViewController *myNewGameVC;
    UIViewController *currentTriviaController;
    
}

@property (nonatomic, retain) UILabel *scoreLabel;
@property (nonatomic, retain) UIProgressView *timeProgressView;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) EndOfGameViewController *endOfGameVC;
@property (nonatomic, retain) NewGameViewController *myNewGameVC;
@property (nonatomic, retain) UIViewController *currentTriviaController;


@end
