//
//  KTLink.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//   
//

#import "KTLink.h"

@implementation KTLink
@synthesize linkDescription, url;

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    self.url = nil;
    self.linkDescription = nil;
    [super dealloc];
}

@end
