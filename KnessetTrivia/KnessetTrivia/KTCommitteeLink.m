//
//  KTCommittee.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTCommitteeLink.h"

@implementation KTCommitteeLink
@synthesize committeeDescription,url;


- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    self.url = nil;
    self.committeeDescription = nil;
    [super dealloc];
}

@end