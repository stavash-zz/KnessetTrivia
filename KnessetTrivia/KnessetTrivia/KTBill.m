//
//  KTBill.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTBill.h"

@implementation KTBill
@synthesize billTitle,comitteeMeetings,proposals,popularName,proposingMks,stageDate,stageText,tags,url,votes;

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    self.billTitle = nil;
    self.comitteeMeetings = nil;
    self.popularName = nil;
    self.proposals = nil;
    self.proposingMks = nil;
    self.stageDate = nil;
    self.stageText = nil;
    self.tags = nil;
    self.url = nil;
    self.votes = nil;
    [super dealloc];
}

@end
