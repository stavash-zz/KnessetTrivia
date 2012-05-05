//
//  GameFlowDelegateProtocol.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/3/12.
//   
//

#import <Foundation/Foundation.h>

@protocol GameFlowDelegate <NSObject>
@optional
- (void) newGameRequested;
- (void) reEnableGeneralScreenRequested;
@end
