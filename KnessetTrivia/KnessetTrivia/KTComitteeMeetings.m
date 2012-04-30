//
//  KTComitteeMeetings.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTComitteeMeetings.h"

@implementation KTComitteeMeetings
@synthesize all,first,second;

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    self.all = nil;
    self.first = nil;
    self.second = nil;
    [super dealloc];
}

@end
