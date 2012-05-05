//
//  GeneralTriviaDelegateProtocol.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/3/12.
//   
//

#import <Foundation/Foundation.h>

@protocol GeneralTriviaDelegate <NSObject>
@optional
- (void) advanceToNextQuestion;
@end
