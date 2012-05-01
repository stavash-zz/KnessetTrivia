//
//  MemberCellFlipSideViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@class KTMember;

@protocol FlipSideDelegate <NSObject>
- (void) flipSideDismiss;
@end

@interface MemberCellFlipSideViewController : UIViewController <UIActionSheetDelegate,MFMailComposeViewControllerDelegate>{

    id <FlipSideDelegate> delegate;
    IBOutlet UILabel *memberNameLabel;
    KTMember *member;
    MFMailComposeViewController *mailVC;
}

@property (assign) id <FlipSideDelegate> delegate;
@property (nonatomic, retain) MFMailComposeViewController *mailVC;
@property (nonatomic, retain) KTMember *member;

@end
