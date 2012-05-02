//
//  EndOfGameViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameFlowDelegate <NSObject>
@optional
- (void) newGameRequested;
@end

@interface EndOfGameViewController : UIViewController {
    id <GameFlowDelegate> delegate;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UIView *scoreBgView;
}

@property (assign) id <GameFlowDelegate> delegate;

- (IBAction)playAgainPressed:(id)sender;

@end
