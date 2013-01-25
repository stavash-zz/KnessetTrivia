//
//  NewGameViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/3/12.
//   
//

#import <UIKit/UIKit.h>
#import "GameFlowDelegateProtocol.h"
#import "UpdateDelegateProtocol.h"

typedef enum {
    kStartPhrase1,
    kStartPhrase2,
    kStartPhrase3,
    kStartPhrase4,
    kStartPhrase5,
    startPhraseCount
}StartPhrase;

@interface NewGameViewController : UIViewController <UpdateDelegate> {
    id <GameFlowDelegate> delegate;
    IBOutlet UILabel *startPhraseLabel;
    IBOutlet UILabel *welcomeLabel;
    IBOutlet UIButton *facebookButton;
    BOOL firstGameEver;
}

@property (assign) id <GameFlowDelegate> delegate;

@end
