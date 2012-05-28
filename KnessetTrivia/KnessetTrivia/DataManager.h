//
//  KTDataManager.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//   
//

#import <Foundation/Foundation.h>
#import "KTMember.h"

@interface DataManager : NSObject {
    NSArray *members;
    NSArray *bills;
    NSArray *parties;
}


@property (nonatomic, retain) NSArray *members;
@property (nonatomic, retain) NSArray *bills;
@property (nonatomic, retain) NSArray *parties;

//General
+ (DataManager *) sharedManager;
- (void) initializeMembers;
- (void) initializeBills;
- (void) initializeParties;

//Queries
- (KTMember *) getMemberWithId:(int)memberId;
- (NSArray *) getMembersOfGender:(MemberGender)gender;
- (NSArray *) getAllMemberNames;
- (NSArray *) getAllParties;
- (NSArray *) getAllPlacesOfBirth;
- (NSArray *) getAllRolesForGender:(MemberGender)gender;
- (NSArray *) getFourRandomMembersOfGender:(MemberGender)gender;
- (KTMember *) getRandomMember;
- (KTMember *) getRandomMemberWithRole;
- (int) getAgeForMember:(KTMember *)member;
- (int) getPartyIdForName:(NSString *)partyName;

//Caching
- (UIImage *)getImageForMemberId:(int)memberId;
- (UIImage *)savedImageForId:(int)imageId;
- (void) saveImageToTempDirectory:(UIImage *)image withId:(int)imageId;
- (void) saveAllImagesLocally;

@end

