//
//  FirstViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberCellViewController;

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    MemberCellViewController *myMemberCell;
}

@property (nonatomic, retain) MemberCellViewController *myMemberCell;
@end
