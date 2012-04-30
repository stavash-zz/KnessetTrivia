//
//  KTCommitteeMeeting.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTCommitteeMeeting : NSObject {
    int committeeMeetingId;
    NSDate *date;
    NSString *description;
}

@property (assign) int committeeMeetingId;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *description;

@end
