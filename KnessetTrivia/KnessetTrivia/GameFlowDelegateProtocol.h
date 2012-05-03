//
//  GameFlowDelegateProtocol.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameFlowDelegate <NSObject>
@optional
- (void) newGameRequested;
- (void) reEnableGeneralScreenRequested;
@end
