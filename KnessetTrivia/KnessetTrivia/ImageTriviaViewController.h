//
//  ImageTriviaViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralTriviaViewController.h"

typedef enum {
    kCellPositionTopLeft,
    kCellPositionTopRight,
    kCellPositionBottomLeft,
    kCellPositionBottomRight
}CellPosition;

@class MemberCellViewController;

@interface ImageTriviaViewController : GeneralTriviaViewController <UIGestureRecognizerDelegate> {
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
}

@property (nonatomic, retain) MemberCellViewController *topLeftMemberCell;
@property (nonatomic, retain) MemberCellViewController *topRightMemberCell;
@property (nonatomic, retain) MemberCellViewController *bottomLeftMemberCell;
@property (nonatomic, retain) MemberCellViewController *bottomRightMemberCell;
@property (nonatomic, retain) NSArray *optionsArr;

@end
