//
//  KTCommitteeMeeting.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTCommitteeMeeting.h"

@implementation KTCommitteeMeeting
@synthesize committeeMeetingId,date,description;

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    self.date = nil;
    self.description = nil;
    [super dealloc];
}

@end
