//
//  NewGameViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameFlowDelegateProtocol.h"
@interface NewGameViewController : UIViewController {
    id <GameFlowDelegate> delegate;
}

@property (assign) id <GameFlowDelegate> delegate;

@end
