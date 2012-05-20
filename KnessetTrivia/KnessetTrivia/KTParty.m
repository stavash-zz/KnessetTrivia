//
//  KTParty.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/13/12.
//

#import "KTParty.h"

@implementation KTParty

@synthesize partyId,name,startDate,endDate;

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    self.name = nil;
    self.startDate = nil;
    self.endDate = nil;
    [super dealloc];
}


@end
