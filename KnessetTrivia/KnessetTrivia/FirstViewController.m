//
//  FirstViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "SBJsonParser.h"
#import "KTMember.h"
#import "KTLink.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (NSArray *)parseBillsArrayFromTree:(NSArray *)billsTree {
    
}

- (NSArray *)parseMemberLinksFromTree:(NSArray *)linksTree {
    NSMutableArray *linksArr = [[NSMutableArray alloc] init];
    for (NSArray *linkArr in linksTree) {
        KTLink *link = [[KTLink alloc] init];
        link.linkDescription = [linkArr objectAtIndex:0];
        link.url = [linkArr objectAtIndex:1];
        [linksArr addObject:link];
    }
    return [NSArray arrayWithArray:linksArr];
}
							
- (void)viewDidLoad
{
    NSDateFormatter *generalDateFormatter = [[NSDateFormatter alloc] init];
    generalDateFormatter.dateFormat = @"YYYY-mm-dd";
    
    NSData *memberData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"member" ofType:@"txt"]];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"tmp.txt"];
//    [memberData writeToFile:filePath atomically:YES];
    NSString *jsonString = [[NSString alloc] initWithData:memberData encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSArray *jsonObjects = (NSArray *)[jsonParser objectWithString:jsonString error:&error];
    if ([error localizedDescription]) {
        NSLog(@"Members parsing failed with error: %@",[error localizedDescription]);
    } else {
        NSLog(@"Members parsed successfuly");
    }
    
    NSMutableArray *membersArr = [[NSMutableArray alloc] init];
    for (NSDictionary *memberDict in jsonObjects) {
        KTMember *member = [[KTMember alloc] init];
        
        [member setAreaOfResidence:[memberDict objectForKey:@"area_of_residence"]];
        
        id averageWeeklyPresenceStr = [memberDict objectForKey:@"average_weekly_presence"];
        if (averageWeeklyPresenceStr != [NSNull null]) {
            [member setAverageWeeklyPresence:[(NSString *)averageWeeklyPresenceStr floatValue]];
        }
        [member setAverageWeeklyPresenceRank:[[memberDict objectForKey:@"average_weekly_presence_rank"] intValue]];
//        [member setBills:[self parseBillsArrayFromTree:[memberDict objectForKey:@"bills"]]];
        [member setBillsApproved:[[memberDict objectForKey:@"bills_approved"] intValue]];
        [member setBillsPassedFirstVote:[[memberDict objectForKey:@"bills_passed_first_vote"] intValue]];
        [member setBillsPassedPreVote:[[memberDict objectForKey:@"bills_passed_pre_vote"] intValue]];
        [member setBillsProposed:[[memberDict objectForKey:@"bills_proposed"] intValue]];
        [member setCommitteeMeetingsPerMonth:[[memberDict objectForKey:@"committee_meetings_per_month"] floatValue]];
//        [member setCommittees:[self parseCommitteesArrayFromTree:[memberDict objectForKey:@"committees"]]];
        [member setCurrentRoleDescriptions:[memberDict objectForKey:@"current_role_descriptions"]];
        
        id dateOfBirthStr = [memberDict objectForKey:@"date_of_birth"];
        if (dateOfBirthStr != [NSNull null]) {
            [member setDateOfBirth:[generalDateFormatter dateFromString:(NSString *)dateOfBirthStr]];
        }

        id dateOfDeathStr = [memberDict objectForKey:@"date_of_death"];
        if (dateOfDeathStr != [NSNull null]) {
            [member setDateOfDeath:[generalDateFormatter dateFromString:(NSString *)dateOfDeathStr]];
        }
        
        [member setDiscipline:[[memberDict objectForKey:@"discipline"] floatValue]];
        [member setEmail:[memberDict objectForKey:@"email"]];
        
        id endDateStr = [memberDict objectForKey:@"date_of_birth"];
        if (endDateStr != [NSNull null]) {
            [member setEndDate:[generalDateFormatter dateFromString:(NSString *)endDateStr]];
        }
        
        [member setFamilyStatus:[memberDict objectForKey:@"family_status"]];
        [member setFax:[memberDict objectForKey:@"fax"]];
        
        id genderStr = [memberDict objectForKey:@"gender"];
        if (genderStr != [NSNull null]) {
            if ([(NSString *)genderStr isEqualToString:@"זכר"]) {
                member.gender = kGenderMale;
            } else if ([(NSString *)genderStr isEqualToString:@"נקבה"]) {
                member.gender = kGenderFemale;
            }
        }
        
        [member setMemberId:[[memberDict objectForKey:@"id"] intValue]];
        [member setImageUrl:[memberDict objectForKey:@"img_url"]];
        [member setIsCurrent:[[memberDict objectForKey:@"is_current"] intValue]];
        [member setLinks:[self parseMemberLinksFromTree:[memberDict objectForKey:@"links"]]];
        [member setName:[memberDict objectForKey:@"name"]];
        
        id numberOfChildrenStr = [memberDict objectForKey:@"number_of_children"];
        if (numberOfChildrenStr != [NSNull null]) {
            [member setNumberOfChildren:[(NSString *)numberOfChildrenStr intValue]];
        }
        [member setParty:[memberDict objectForKey:@"party"]];
        [member setPhone:[memberDict objectForKey:@"phone"]];
        [member setPlaceOfBirth:[memberDict objectForKey:@"place_of_birth"]];
        [member setPlaceOfResidence:[memberDict objectForKey:@"place_of_residence"]];
        
        id placeOfBirthLatStr = [memberDict objectForKey:@"place_of_residence_lat"];
        if (placeOfBirthLatStr != [NSNull null]) {
            [member setPlaceOfBirthLat:[(NSString *)placeOfBirthLatStr floatValue]];
        }
        
        id placeOfBirthLonStr = [memberDict objectForKey:@"place_of_residence_lon"];
        if (placeOfBirthLonStr != [NSNull null]) {
            [member setPlaceOfBirthLon:[(NSString *)placeOfBirthLonStr floatValue]];
        }
        
        id residenceCentralityStr = [memberDict objectForKey:@"residence_centrality"];
        if (residenceCentralityStr != [NSNull null]) {
            [member setResidenceCentrality:[(NSString *)residenceCentralityStr intValue]];
        }
        
        id residenceEconomyStr = [memberDict objectForKey:@"residence_economy"];
        if (residenceCentralityStr != [NSNull null]) {
            [member setResidenceEconomy:[(NSString *)residenceEconomyStr intValue]];
        }
        [member setRoles:[memberDict objectForKey:@"roles"]];
        [member setServiceTime:[[memberDict objectForKey:@"service_time"] intValue]];
        
        id startDateStr = [memberDict objectForKey:@"start_date"];
        if (startDateStr != [NSNull null]) {
            [member setStartDate:[generalDateFormatter dateFromString:(NSString *)startDateStr]];
        }
        
        [member setUrl:[memberDict objectForKey:@"url"]];
        [member setVotesCount:[[memberDict objectForKey:@"votes_count"] intValue]];
        [member setVotesPerMonth:[[memberDict objectForKey:@"votes_per_month"] floatValue]];
        
        id yearOfAliyahStr = [memberDict objectForKey:@"year_of_aliyah"];
        if (yearOfAliyahStr != [NSNull null]) {
            [member setYearOfAliyah:[(NSString *)yearOfAliyahStr intValue]];
        }
         
        [membersArr addObject:member];
        [member release];
    }
    
    [jsonParser release], jsonParser = nil;
    [generalDateFormatter release], generalDateFormatter = nil;
    [membersArr release], membersArr = nil;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
