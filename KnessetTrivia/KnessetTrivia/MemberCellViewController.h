//
//  MemberTableCell.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberCellFlipSideViewController.h"

@class KTMember;
@class MemberCellFlipSideViewController;

@interface MemberCellViewController : UIViewController <FlipSideDelegate>{
    IBOutlet UIImageView *imgView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UIActivityIndicatorView *aiv;
    IBOutlet UIButton *infoButton;
    MemberCellFlipSideViewController *flipSideVC;
    KTMember *member;

}

@property (nonatomic, retain) KTMember *member;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) MemberCellFlipSideViewController *flipSideVC;

- (void) showCorrectIndication;
- (void) showWrongIndication;
- (IBAction)infoPressed:(id)sender;
- (void)showInfoButton;
- (void)hideInfoButton;
@end
