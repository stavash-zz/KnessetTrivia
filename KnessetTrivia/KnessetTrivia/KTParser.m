//
//  KTParser.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTParser.h"

#import "SBJsonParser.h"
#import "KTParserStrings.h"
#import "KTMember.h"
#import "KTLink.h"
#import "KTCommitteeLink.h"
#import "KTBillLink.h"

@implementation KTParser

+ (NSArray *)parseBillsArrayFromTree:(NSArray *)billsTree {
    NSMutableArray *billsArr = [[[NSMutableArray alloc] init] autorelease];
    for (NSDictionary *billDict in billsTree) {
        KTBillLink *bill = [[KTBillLink alloc] init];
        [bill setBillTitle:[billDict objectForKey:kParserKeyBillTitle]];
        [bill setUrl:[billDict objectForKey:kParserKeyBillUrl]];
        [billsArr addObject:bill];
        [bill release];
    }
    return [NSArray arrayWithArray:billsArr];
    
}

+ (NSArray *)parseCommitteesArrayFromTree:(NSArray *)committeeTree {
    NSMutableArray *committeesArr = [[[NSMutableArray alloc] init] autorelease];
    for (NSArray *committeeArr in committeeTree) {
        KTCommitteeLink *committee = [[KTCommitteeLink alloc] init];
        [committee setCommitteeDescription:[committeeArr objectAtIndex:0]];
        [committee setUrl:[committeeArr objectAtIndex:1]];
        [committeesArr addObject:committee];
        [committee release];
    }
    return [NSArray arrayWithArray:committeesArr];
}

+ (NSArray *)parseMemberLinksFromTree:(NSArray *)linksTree {
    NSMutableArray *linksArr = [[[NSMutableArray alloc] init] autorelease];
    for (NSArray *linkArr in linksTree) {
        KTLink *link = [[KTLink alloc] init];
        link.linkDescription = [linkArr objectAtIndex:0];
        link.url = [linkArr objectAtIndex:1];
        [linksArr addObject:link];
        [link release];
    }
    return [NSArray arrayWithArray:linksArr];
}

+ (NSArray *)parseMembersFromTree:(NSArray *)membersTree {
    NSDateFormatter *generalDateFormatter = [[NSDateFormatter alloc] init];
    generalDateFormatter.dateFormat = kParserGeneralDateFormat; 
    generalDateFormatter.timeZone = [NSTimeZone timeZoneWithName:kParserGeneralDateTimezoneName];

    NSMutableArray *membersArr = [[[NSMutableArray alloc] init] autorelease];
    for (NSDictionary *memberDict in membersTree) {
        KTMember *member = [[KTMember alloc] init];
        
        [member setAreaOfResidence:[memberDict objectForKey:kParserKeyAreaOfResidence]];
        
        id averageWeeklyPresenceStr = [memberDict objectForKey:kParserKeyAverageWeeklyPresence];
        if (averageWeeklyPresenceStr != [NSNull null]) {
            [member setAverageWeeklyPresence:[(NSString *)averageWeeklyPresenceStr floatValue]];
        }
        
        [member setAverageWeeklyPresenceRank:[[memberDict objectForKey:kParserKeyAverageWeeklyPresenceRank] intValue]];
        [member setBills:[KTParser parseBillsArrayFromTree:[memberDict objectForKey:kParserKeyBills]]];
        [member setBillsApproved:[[memberDict objectForKey:kParserKeyBillsApproved] intValue]];
        [member setBillsPassedFirstVote:[[memberDict objectForKey:kParserKeyBillsPassedFirstVote] intValue]];
        [member setBillsPassedPreVote:[[memberDict objectForKey:kParserKeyBillsPassedPreVote] intValue]];
        [member setBillsProposed:[[memberDict objectForKey:kParserKeyBillsProposed] intValue]];
        [member setCommitteeMeetingsPerMonth:[[memberDict objectForKey:kParserKeyCommitteeMeetingsPerMonth] floatValue]];
        [member setCommittees:[KTParser parseCommitteesArrayFromTree:[memberDict objectForKey:kParserKeyCommittees]]];
        [member setCurrentRoleDescriptions:[memberDict objectForKey:kParserKeyCurrentRoleDescriptions]];
        
        id dateOfBirthStr = [memberDict objectForKey:kParserKeyDateOfBirth];
        if (dateOfBirthStr != [NSNull null]) {
            [member setDateOfBirth:[generalDateFormatter dateFromString:(NSString *)dateOfBirthStr]];
        }
        
        id dateOfDeathStr = [memberDict objectForKey:kParserKeyDateOfDeath];
        if (dateOfDeathStr != [NSNull null]) {
            [member setDateOfDeath:[generalDateFormatter dateFromString:(NSString *)dateOfDeathStr]];
        }
        
        [member setDiscipline:[[memberDict objectForKey:kParserKeyDiscipline] floatValue]];
        [member setEmail:[memberDict objectForKey:kParserKeyEmail]];
        
        id endDateStr = [memberDict objectForKey:kParserKeyEndDate];
        if (endDateStr != [NSNull null]) {
            [member setEndDate:[generalDateFormatter dateFromString:(NSString *)endDateStr]];
        }
        
        [member setFamilyStatus:[memberDict objectForKey:kParserKeyFamilyStatus]];
        [member setFax:[memberDict objectForKey:kParserKeyFax]];
        
        id genderStr = [memberDict objectForKey:kParserKeyGender];
        if (genderStr != [NSNull null]) {
            if ([(NSString *)genderStr isEqualToString:kParserKeyGenderMale]) {
                member.gender = kGenderMale;
            } else if ([(NSString *)genderStr isEqualToString:kParserKeyGenderFemale]) {
                member.gender = kGenderFemale;
            }
        }
        
        [member setMemberId:[[memberDict objectForKey:kParserKeyId] intValue]];
        [member setImageUrl:[memberDict objectForKey:kParserKeyImgUrl]];
        [member setIsCurrent:[[memberDict objectForKey:kParserKeyIsCurrent] intValue]];
        [member setLinks:[KTParser parseMemberLinksFromTree:[memberDict objectForKey:kParserKeyLinks]]];
        [member setName:[memberDict objectForKey:kParserKeyName]];
        
        id numberOfChildrenStr = [memberDict objectForKey:kParserKeyNumberOfChildren];
        if (numberOfChildrenStr != [NSNull null]) {
            [member setNumberOfChildren:[(NSString *)numberOfChildrenStr intValue]];
        }
        
        [member setParty:[memberDict objectForKey:kParserKeyParty]];
        [member setPhone:[memberDict objectForKey:kParserKeyPhone]];
        [member setPlaceOfBirth:[memberDict objectForKey:kParserKeyPlaceOfBirth]];
        [member setPlaceOfResidence:[memberDict objectForKey:kParserKeyPlaceOfResidence]];
        
        id placeOfBirthLatStr = [memberDict objectForKey:kParserKeyPlaceOfResidenceLat];
        if (placeOfBirthLatStr != [NSNull null]) {
            [member setPlaceOfBirthLat:[(NSString *)placeOfBirthLatStr floatValue]];
        }
        
        id placeOfBirthLonStr = [memberDict objectForKey:kParserKeyPlaceOfResidenceLon];
        if (placeOfBirthLonStr != [NSNull null]) {
            [member setPlaceOfBirthLon:[(NSString *)placeOfBirthLonStr floatValue]];
        }
        
        id residenceCentralityStr = [memberDict objectForKey:kParserKeyResidenceCentrality];
        if (residenceCentralityStr != [NSNull null]) {
            [member setResidenceCentrality:[(NSString *)residenceCentralityStr intValue]];
        }
        
        id residenceEconomyStr = [memberDict objectForKey:kParserKeyResidenceEconomy];
        if (residenceCentralityStr != [NSNull null]) {
            [member setResidenceEconomy:[(NSString *)residenceEconomyStr intValue]];
        }
        [member setRoles:[memberDict objectForKey:kParserKeyRoles]];
        [member setServiceTime:[[memberDict objectForKey:kParserKeyServiceTime] intValue]];
        
        id startDateStr = [memberDict objectForKey:kParserKeyStartDate];
        if (startDateStr != [NSNull null]) {
            [member setStartDate:[generalDateFormatter dateFromString:(NSString *)startDateStr]];
        }
        
        [member setUrl:[memberDict objectForKey:kParserKeyUrl]];
        [member setVotesCount:[[memberDict objectForKey:kParserKeyVotesCount] intValue]];
        [member setVotesPerMonth:[[memberDict objectForKey:kParserKeyVotesPerMonth] floatValue]];
        
        id yearOfAliyahStr = [memberDict objectForKey:kParserKeyYearOfAliyah];
        if (yearOfAliyahStr != [NSNull null]) {
            [member setYearOfAliyah:[(NSString *)yearOfAliyahStr intValue]];
        }
        
        [membersArr addObject:member];
        [member release];
    }
    return [NSArray arrayWithArray:membersArr];
}

@end
