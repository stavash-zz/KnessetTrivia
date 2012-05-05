//
//  EndOfGameViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/2/12.
//   
//

#import <UIKit/UIKit.h>
#import "GameFlowDelegateProtocol.h"

@interface EndOfGameViewController : UIViewController {
    id <GameFlowDelegate> delegate;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UIView *scoreBgView;
}

@property (assign) id <GameFlowDelegate> delegate;

@end
