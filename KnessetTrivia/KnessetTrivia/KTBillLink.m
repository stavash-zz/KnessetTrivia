//
//  KTBill.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTBillLink.h"

@implementation KTBillLink
@synthesize billTitle,url;

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    self.url = nil;
    self.billTitle = nil;
    [super dealloc];
}

@end
