//
//  KTParser.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//   
//

#import "KTParser.h"

#import "SBJsonParser.h"
#import "KTParserStrings.h"
#import "KTMember.h"
#import "KTLink.h"
#import "KTCommitteeLink.h"
#import "KTBillLink.h"
#import "KTBill.h"
#import "KTComitteeMeetings.h"
#import "KTCommitteeMeeting.h"

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
        
        id currentRoleDescriptionsStr = [memberDict objectForKey:kParserKeyCurrentRoleDescriptions];
        if (currentRoleDescriptionsStr != [NSNull null]) {
            [member setCurrentRoleDescriptions:currentRoleDescriptionsStr];
        }
        
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
    [generalDateFormatter release];
    return [NSArray arrayWithArray:membersArr];
}

+ (KTCommitteeMeeting *)parseCommitteeMeetingFromTree:(NSDictionary *)committeeMeetingTree {
    NSDateFormatter *generalDateFormatter = [[NSDateFormatter alloc] init];
    generalDateFormatter.dateFormat = kParserGeneralDateFormat; 
    generalDateFormatter.timeZone = [NSTimeZone timeZoneWithName:kParserGeneralDateTimezoneName];

    KTCommitteeMeeting *meeting = [[[KTCommitteeMeeting alloc] init] autorelease];
    [meeting setCommitteeMeetingId:[[committeeMeetingTree objectForKey:@"id"]intValue]];
    [meeting setDate:[generalDateFormatter dateFromString:[committeeMeetingTree objectForKey:@"date"]]];
    [meeting setDescription:[committeeMeetingTree objectForKey:@"description"]];
    
    [generalDateFormatter release];
    return meeting;
}

+ (KTComitteeMeetings *)parseCommitteeMeetingsFromTree:(NSDictionary *)committeeMeetingsTree {
    KTComitteeMeetings *committeeMeetings = [[[KTComitteeMeetings alloc] init] autorelease];
    
    NSMutableArray *allMeetingsArr = [[NSMutableArray alloc] init];
    NSArray *allArr = [committeeMeetingsTree objectForKey:@"all"];
    for (NSDictionary *committeeMeetingDict in allArr) {
        KTCommitteeMeeting *meeting = [KTParser parseCommitteeMeetingFromTree:committeeMeetingDict];
        [allMeetingsArr addObject:meeting];
    }
    committeeMeetings.all = [NSArray arrayWithArray:allMeetingsArr];
    [allMeetingsArr release];
    
    NSMutableArray *firstMeetingsArr = [[NSMutableArray alloc] init];
    NSArray *firstArr = [committeeMeetingsTree objectForKey:@"first"];
    for (NSDictionary *committeeMeetingDict in firstArr) {
        KTCommitteeMeeting *meeting = [KTParser parseCommitteeMeetingFromTree:committeeMeetingDict];
        [firstMeetingsArr addObject:meeting];
    }
    committeeMeetings.first = [NSArray arrayWithArray:firstMeetingsArr];
    [firstMeetingsArr release];
    
    NSMutableArray *secondMeetingsArr = [[NSMutableArray alloc] init];
    NSArray *secondArr = [committeeMeetingsTree objectForKey:@"second"];
    for (NSDictionary *committeeMeetingDict in secondArr) {
        KTCommitteeMeeting *meeting = [KTParser parseCommitteeMeetingFromTree:committeeMeetingDict];
        [secondMeetingsArr addObject:meeting];
    }
    committeeMeetings.second = [NSArray arrayWithArray:secondMeetingsArr];
    [secondMeetingsArr release];

    return committeeMeetings;
}

+ (NSArray *)parseProposingMKsFromTree:(NSArray *)proposingMKsTree {
    NSMutableArray *proposingMKIDs = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSDictionary *proposingMK in proposingMKsTree) {
        NSString *mkIdAsStr = [proposingMK objectForKey:@"id"];
        int mkId = [mkIdAsStr intValue];
        NSNumber *mkIdAsNum = [NSNumber numberWithInt:mkId];
        [proposingMKIDs addObject:mkIdAsNum];
    }
    return [NSArray arrayWithArray:proposingMKIDs];;
}

+ (void)parseVoteFromTree:(NSDictionary *)votesTree toDict:(NSMutableDictionary *)votedict fromkey:(NSString *)votekey {
    id object = [votesTree objectForKey:votekey];
    if (object != [NSNull null]) {
        NSDictionary *objDict = (NSDictionary *)object;
        NSString *voteIdAsStr = [objDict objectForKey:@"id"];
        int voteId = [voteIdAsStr intValue];
        NSNumber *voteIdAsNum = [NSNumber numberWithInt:voteId];
        [votedict setValue:voteIdAsNum forKey:votekey];
    }
}

+ (void)parsePreVoteFromTree:(NSDictionary *)votesTree toDict:(NSMutableDictionary *)votedict fromkey:(NSString *)votekey {
    id object = [votesTree objectForKey:votekey];
    if (object != [NSNull null]) {
        NSArray *objArr = (NSArray *)object;
        if ([objArr count] > 0) {
            NSString *voteIdAsStr = [[objArr objectAtIndex:0] objectForKey:@"id"];
            int voteId = [voteIdAsStr intValue];
            NSNumber *voteIdAsNum = [NSNumber numberWithInt:voteId];
            [votedict setValue:voteIdAsNum forKey:votekey];
        }
    }
}

+ (NSDictionary *)parseVotesFromTree:(NSDictionary *)votesTree    {
    NSMutableDictionary *votes =[[[NSMutableDictionary alloc] init] autorelease];
    
    [KTParser parsePreVoteFromTree:votesTree toDict:votes fromkey:@"pre"];
    [KTParser parseVoteFromTree:votesTree toDict:votes fromkey:@"first"];
    [KTParser parseVoteFromTree:votesTree toDict:votes fromkey:@"approval"];
    
    return [NSDictionary dictionaryWithDictionary:(votes)];

}

+ (NSArray *)parseBillsFromTree:(NSArray *)billsTree {
    NSDateFormatter *generalDateFormatter = [[NSDateFormatter alloc] init];
    generalDateFormatter.dateFormat = kParserGeneralDateFormat; 
    generalDateFormatter.timeZone = [NSTimeZone timeZoneWithName:kParserGeneralDateTimezoneName];
    
    NSMutableArray *billsArr = [[[NSMutableArray alloc] init] autorelease];
    for (NSDictionary *billDict in billsTree) {
        KTBill *bill = [[KTBill alloc] init];

        [bill setBillTitle:[billDict objectForKey:@"bill_title"]];
        [bill setComitteeMeetings:[KTParser parseCommitteeMeetingsFromTree:[billDict objectForKey:@"committee_meetings"]]];
        [bill setPopularName:[billDict objectForKey:@"popular_name"]];
        [bill setProposingMks:[KTParser parseProposingMKsFromTree:[billDict objectForKey:@"proposing_mks"]]];
        
        id stageDateStr = [billDict objectForKey:@"stage_date"];
        if (stageDateStr != [NSNull null]) {
            [bill setStageDate:[generalDateFormatter dateFromString:(NSString *)stageDateStr]];
        }
        
        [bill setStageText:[billDict objectForKey:@"stage_text"]];
        [bill setUrl:[billDict objectForKey:@"url"]];
        [bill setVotes:[KTParser parseVotesFromTree:[billDict objectForKey:kParserKeyVotes]]];
        
        [billsArr addObject:bill];
        [bill release];
    }
    [generalDateFormatter release];
    return [NSArray arrayWithArray:billsArr];
}


@end
