//
//  FirstViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberCell;

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    MemberCell *myMemberCell;
}

@property (nonatomic, retain) MemberCell *myMemberCell;
@end
