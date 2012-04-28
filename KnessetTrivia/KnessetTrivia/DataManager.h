//
//  KTDataManager.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KTMember;

@interface DataManager : NSObject {
    NSArray *members;
}

@property (nonatomic,retain) NSArray *members;

+ (DataManager *) sharedManager;

- (void) initializeMembers;
- (KTMember *)getMemberWithId:(int)memberId;
- (NSArray *)getAllMemberNames;
- (UIImage *)savedImageForId:(int)imageId;
- (void) saveImageToDocuments:(UIImage *)image withId:(int)imageId;
- (NSArray *)getAllParties;

@end

