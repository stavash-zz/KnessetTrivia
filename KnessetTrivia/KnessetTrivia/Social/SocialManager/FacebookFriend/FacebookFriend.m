//
//  FacebookFriend.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 12/7/12.
//  Copyright (c) 2012 Stav Ashuri. All rights reserved.
//

#import "FacebookFriend.h"

@implementation FacebookFriend
@synthesize name;
@synthesize imageUrl;
@synthesize uid;

- (void) dealloc {
    self.name = nil;
    self.imageUrl = nil;
    self.uid = nil;
    [super dealloc];
}

@end
