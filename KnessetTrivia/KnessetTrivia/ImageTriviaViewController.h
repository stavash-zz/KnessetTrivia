//
//  ImageTriviaViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/28/12.
//   
//

#import <UIKit/UIKit.h>
#import "GeneralTriviaViewController.h"
#import "GeneralTriviaDelegateProtocol.h"

typedef enum {
    kCellPositionTopLeft,
    kCellPositionTopRight,
    kCellPositionBottomLeft,
    kCellPositionBottomRight
}CellPosition;

@class MemberCellViewController;

@interface ImageTriviaViewController : UIViewController <UIGestureRecognizerDelegate> {

    id <GeneralTriviaDelegate> delegate;
    
    int correctIndex;
    NSArray *optionsArr;

    IBOutlet UILabel *questionLabel;

    IBOutlet UIView *topLeftView;
    IBOutlet UIView *topRightView;
    IBOutlet UIView *bottomLeftView;
    IBOutlet UIView *bottomRightView;
    
    IBOutlet UIButton *helpButton;

    MemberCellViewController *topLeftMemberCell;
    MemberCellViewController *topRightMemberCell;
    MemberCellViewController *bottomLeftMemberCell;
    MemberCellViewController *bottomRightMemberCell;
    
    int secondsElapsed;
    int tries;
    NSTimer *gameTimer;
    NSMutableArray *choicesArr;
    NSMutableArray *otherChoicesArr;
}

@property (assign) id <GeneralTriviaDelegate> delegate;

@property (nonatomic, retain) MemberCellViewController *topLeftMemberCell;
@property (nonatomic, retain) MemberCellViewController *topRightMemberCell;
@property (nonatomic, retain) MemberCellViewController *bottomLeftMemberCell;
@property (nonatomic, retain) MemberCellViewController *bottomRightMemberCell;
@property (nonatomic, retain) NSArray *optionsArr;
@property (nonatomic, retain) NSTimer *gameTimer;
@property (nonatomic, retain) NSMutableArray *choicesArr;
@property (nonatomic, retain) NSMutableArray *otherChoicesArr;


- (IBAction)helpPressed:(id)sender;

@end
