//
//  ImageTriviaViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    kCellPositionTopLeft,
    kCellPositionTopRight,
    kCellPositionBottomLeft,
    kCellPositionBottomRight
}CellPosition;
@class MemberCell;

@interface ImageTriviaViewController : UIViewController {
    int correctIndex;
    NSArray *optionsArr;

    IBOutlet UILabel *questionLabel;
    IBOutlet UILabel *scoreLabel;

    IBOutlet UIView *topLeftView;
    IBOutlet UIView *topRightView;
    IBOutlet UIView *bottomLeftView;
    IBOutlet UIView *bottomRightView;

    MemberCell *topLeftMemberCell;
    MemberCell *topRightMemberCell;
    MemberCell *bottomLeftMemberCell;
    MemberCell *bottomRightMemberCell;
}

@property (nonatomic, retain) MemberCell *topLeftMemberCell;
@property (nonatomic, retain) MemberCell *topRightMemberCell;
@property (nonatomic, retain) MemberCell *bottomLeftMemberCell;
@property (nonatomic, retain) MemberCell *bottomRightMemberCell;
@property (nonatomic, retain) NSArray *optionsArr;

@end
