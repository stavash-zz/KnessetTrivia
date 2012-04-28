//
//  MemberTableCell.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTMember;

@interface MemberCell : UIViewController <UIActionSheetDelegate>{
    IBOutlet UIImageView *imgView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UIActivityIndicatorView *aiv;
    KTMember *member;
}

@property (nonatomic, retain) KTMember *member;

- (void) showCorrectIndication;
- (void) showWrongIndication;

@end
