//
//  KTMember.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kGenderMale,
    kGenderFemale
}MemberGender;

@interface KTMember : NSObject {
    NSString *areaOfResidence;
    float averageWeeklyPresence;
    int averageWeeklyPresenceRank;
    NSArray *bills;
    int billsApproved;
    int billsPassedFirstVote;
    int billsPassedPreVote;
    int billsProposed;
    float committeeMeetingsPerMonth;
    NSArray *committees;
    NSString *currentRoleDescriptions;
    NSDate *dateOfBirth;
    NSDate *dateOfDeath;
    float discipline;
    NSString *email;
    NSDate *endDate;
    NSString *familyStatus;
    NSString *fax;
    MemberGender gender;
    int memberId;
    NSString *imageUrl;
    int isCurrent;
    NSArray *links;
    NSString *name;
    int numberOfChildren;
    NSString *party;
    NSString *phone;
    NSString *placeOfBirth;
    NSString *placeOfResidence;
    float placeOfBirthLat;
    float placeOfBirthLon;
    int residenceCentrality;
    int residenceEconomy;
    NSString *roles;
    int serviceTime;
    NSDate *startDate;
    NSString *url;
    int votesCount;
    float votesPerMonth;
    int yearOfAliyah;
}

@property (nonatomic, retain) NSString *areaOfResidence;
@property (nonatomic, retain) NSArray *bills;
@property (nonatomic, retain) NSArray *committees;
@property (nonatomic, retain) NSString *currentRoleDescriptions;
@property (nonatomic, retain) NSDate *dateOfBirth;
@property (nonatomic, retain) NSDate *dateOfDeath;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSString *familyStatus;
@property (nonatomic, retain) NSString *fax;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSArray *links;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *party;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *placeOfBirth;
@property (nonatomic, retain) NSString *placeOfResidence;
@property (nonatomic, retain) NSString *roles;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSString *url;
@property (assign) float averageWeeklyPresence;
@property (assign) int averageWeeklyPresenceRank;
@property (assign) int billsApproved;
@property (assign) int billsPassedFirstVote;
@property (assign) int billsPassedPreVote;
@property (assign) int billsProposed;
@property (assign) float committeeMeetingsPerMonth;
@property (assign) float discipline;
@property (assign) MemberGender gender;
@property (assign) int memberId;
@property (assign) int isCurrent;
@property (assign) int numberOfChildren;
@property (assign) float placeOfBirthLat;
@property (assign) float placeOfBirthLon;
@property (assign) int residenceCentrality;
@property (assign) int residenceEconomy;
@property (assign) int serviceTime;
@property (assign) int votesCount;
@property (assign) float votesPerMonth;
@property (assign) int yearOfAliyah;

@end
