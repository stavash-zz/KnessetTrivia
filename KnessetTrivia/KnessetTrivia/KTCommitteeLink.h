//
//  KTCommittee.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTCommitteeLink : NSObject { //TODO: inherit from superclass with url property
    NSString *committeeDescription;
    NSString *url;
}

@property (nonatomic, retain) NSString *committeeDescription;
@property (nonatomic, retain) NSString *url;

@end
