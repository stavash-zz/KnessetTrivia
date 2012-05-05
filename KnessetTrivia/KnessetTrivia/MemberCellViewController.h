//
//  MemberTableCell.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//   
//

#import <UIKit/UIKit.h>
#import "MemberCellFlipSideViewController.h"

@class KTMember;
@class MemberCellFlipSideViewController;

typedef enum {
    kResultUnknown,
    kResultCorrect,
    kResultWrong
}ResultState;

@interface MemberCellViewController : UIViewController <FlipSideDelegate>{
    IBOutlet UIImageView *imgView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UIActivityIndicatorView *aiv;
    IBOutlet UIButton *infoButton;
    MemberCellFlipSideViewController *flipSideVC;
    KTMember *member;
    
    ResultState myResultState;
}

@property (nonatomic, retain) KTMember *member;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) MemberCellFlipSideViewController *flipSideVC;

@property (assign) ResultState myResultState;

- (void) showCorrectIndication;
- (void) showWrongIndication;
- (IBAction)infoPressed:(id)sender;
- (void)showInfoButton;
- (void)hideInfoButton;
@end
