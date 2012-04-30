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
    int score;
}

@property (nonatomic,retain) NSArray *members;

//General
+ (DataManager *) sharedManager;
- (void) initializeMembers;

//Queries
- (KTMember *)getMemberWithId:(int)memberId;
- (NSArray *)getAllMemberNames;
- (NSArray *)getAllParties;

//Score
- (void)updateCorrectImageAnswer;
- (void)updateWrongImageAnswer;
- (int) getCurrentScore;

//Caching
- (UIImage *)savedImageForId:(int)imageId;
- (void) saveImageToDocuments:(UIImage *)image withId:(int)imageId;


@end
