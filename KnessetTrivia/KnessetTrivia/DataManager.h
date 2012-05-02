//
//  KTDataManager.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTMember.h"

@interface DataManager : NSObject {
    NSArray *members;
    NSArray *bills;
    int score;
}

@property (nonatomic,retain) NSArray *members;
@property (nonatomic,retain) NSArray *bills;


//General
+ (DataManager *) sharedManager;
- (void) initializeMembers;
- (void) initializeBills;

//Queries
- (KTMember *)getMemberWithId:(int)memberId;
- (NSArray *)getMembersOfGender:(MemberGender)gender;
- (NSArray *)getAllMemberNames;
- (NSArray *)getAllParties;
- (NSArray *)getFourRandomMembersOfGender:(MemberGender)gender;
- (KTMember *) getRandomMember;
- (int)getAgeForMember:(KTMember *)member;


//Score
- (void)updateCorrectAnswer;
- (void)updateWrongAnswer;
- (void)updateHelpRequested;
- (NSString *) getCurrentScoreStr;

//Caching
- (UIImage *)getImageForMemberId:(int)memberId;
- (UIImage *)savedImageForId:(int)imageId;
- (void) saveImageToDocuments:(UIImage *)image withId:(int)imageId;


@end

