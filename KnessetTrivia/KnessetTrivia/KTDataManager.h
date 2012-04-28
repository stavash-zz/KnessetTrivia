//
//  KTDataManager.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KTMember;

@interface KTDataManager : NSObject {
    NSArray *members;
}

@property (nonatomic,retain) NSArray *members;

+ (KTDataManager *) sharedManager;

- (void) initializeMembers;
- (KTMember *)getMemberWithId:(int)memberId;

@end

