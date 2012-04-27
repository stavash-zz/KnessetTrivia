//
//  KTMember.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTMember.h"

@implementation KTMember
@synthesize areaOfResidence,bills,committees,currentRoleDescriptions,dateOfBirth,dateOfDeath,email,endDate,familyStatus,fax,imageUrl,links,name,party,phone,placeOfBirth,placeOfResidence,roles,startDate,url;
@synthesize averageWeeklyPresence, averageWeeklyPresenceRank, billsApproved, billsPassedFirstVote, billsPassedPreVote, billsProposed,committeeMeetingsPerMonth, discipline, gender, memberId, isCurrent, numberOfChildren, placeOfBirthLat, placeOfBirthLon, residenceCentrality, residenceEconomy, serviceTime, votesCount, votesPerMonth, yearOfAliyah;

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    self.areaOfResidence = nil;
    self.bills = nil;
    self.committees = nil;
    self.currentRoleDescriptions = nil;
    self.dateOfBirth = nil;
    self.dateOfDeath = nil;
    self.email = nil;
    self.endDate = nil;
    self.familyStatus = nil;
    self.fax = nil;
    self.imageUrl = nil;
    self.links = nil;
    self.name = nil;
    self.party = nil;
    self.phone = nil;
    self.placeOfBirth = nil;
    self.placeOfResidence = nil;
    self.roles = nil;
    self.startDate = nil;
    self.url = nil;

    [super dealloc];
}

@end
