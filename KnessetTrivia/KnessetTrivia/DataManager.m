//
//  KTDataManager.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//   
//

#import "DataManager.h"
#import "SBJsonParser.h"
#import "KTParser.h"
#import "KTBill.h"
#import "KTParty.h"

#define kUpdatedMembersFilename @"updatedMembers.txt"
#define kUpdatedPartiesFilename @"updatedParties.txt"
#define kUpdatedBillsFilename @"updatedBills.txt"

#define kUpdateTimeUserDefaultsKey @"updateTime"

#define kDaysToUpdate 14
#define kTimeIntervalToUpdate kDaysToUpdate * 24.0 * 60.0 * 60.0

typedef enum {
    kResourceTypeMember,
    kResourceTypeParty,
    kResourceTypeBills
}ResourceType;

@implementation DataManager
@synthesize members;
@synthesize bills;
@synthesize parties;
static DataManager *manager = nil;

#pragma mark - Default

+ (DataManager *) sharedManager {
	@synchronized(self) {
		if (!manager) {
			[[DataManager alloc] init];

		}
		return manager;
	}
	return nil;
}

+ (id) alloc {
	@synchronized(self)     {
		manager = [super alloc];
		return manager;
	}
	return nil;
}

- (id) init {
    self=[super init];
	if(self) {

	}
	return self;
}

- (void)dealloc {
    self.members = nil;
    self.bills = nil;
    self.parties = nil;
    [super dealloc];
}

#pragma mark - Private

- (NSArray *)getMembersWithRole {
    NSMutableArray *membersArr = [[[NSMutableArray alloc] init] autorelease];
    for (KTMember *member in self.members) {
        if (member.currentRoleDescriptions) {
            [membersArr addObject:member];
        }
    }
    return [NSArray arrayWithArray:membersArr];
}

#pragma mark - Private (File paths)

+ (NSString *)pathForStoringUpdateDataForResourceType:(ResourceType)type {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = nil;
    switch (type) {
        case kResourceTypeMember:
            path = [documentsDirectory stringByAppendingPathComponent:kUpdatedMembersFilename];
            break;
        case kResourceTypeParty:
            path = [documentsDirectory stringByAppendingPathComponent:kUpdatedPartiesFilename];
            break;
        case kResourceTypeBills:
            path = [documentsDirectory stringByAppendingPathComponent:kUpdatedBillsFilename];
            break;
        default:
            break;
    }
    return path;
}

+ (NSString *) filePathForResourceType:(ResourceType)type {
    NSString *potentialUpdatedDataPath = [DataManager pathForStoringUpdateDataForResourceType:type];
    if ([[NSFileManager defaultManager] fileExistsAtPath:potentialUpdatedDataPath]) {
        return potentialUpdatedDataPath;
    }
    
    switch (type) {
        case kResourceTypeMember:
        {
            return [[NSBundle mainBundle] pathForResource:@"member" ofType:@"txt"];
        }
            break;
        case kResourceTypeParty:
        {
            return [[NSBundle mainBundle] pathForResource:@"bills" ofType:@"txt"];
        }
            break;
        case kResourceTypeBills:
        {
            return [[NSBundle mainBundle] pathForResource:@"party" ofType:@"txt"];
        }
            break;
        default:
            break;
    }

    return nil;
}

#pragma mark - Public

- (void) initializeMembers {
    NSString *filePath = [DataManager filePathForResourceType:kResourceTypeMember];
    NSData *memberData = [NSData dataWithContentsOfFile:filePath];
    
    NSString *jsonString = [[NSString alloc] initWithData:memberData encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSArray *jsonObjects = (NSArray *)[jsonParser objectWithString:jsonString error:&error];
    if ([error localizedDescription]) {
        NSLog(@"Members parsing failed with error: %@",[error localizedDescription]);
    } else {
        NSLog(@"Members parsed successfuly");
    }
    
    self.members = [KTParser parseMembersFromTree:jsonObjects];
    
    [jsonParser release], jsonParser = nil;
    [jsonString release], jsonString = nil;
}

- (void) initializeBills {
    NSString *filePath = [DataManager filePathForResourceType:kResourceTypeBills];
    NSData *billsData = [NSData dataWithContentsOfFile:filePath];
    
    NSString *jsonString = [[NSString alloc] initWithData:billsData encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSArray *jsonObjects = (NSArray *)[jsonParser objectWithString:jsonString error:&error];
    if ([error localizedDescription]) {
        NSLog(@"Bills parsing failed with error: %@",[error localizedDescription]);
    } else {
        NSLog(@"Bills parsed successfuly");
    }
    
    self.bills = [KTParser parseBillsFromTree:jsonObjects];
    
    [jsonParser release], jsonParser = nil;
    [jsonString release], jsonString = nil;
    
}

- (void) initializeParties {
    NSString *filePath = [DataManager filePathForResourceType:kResourceTypeParty];
    NSData *partiesData = [NSData dataWithContentsOfFile:filePath];
    
    NSString *jsonString = [[NSString alloc] initWithData:partiesData encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSArray *jsonObjects = (NSArray *)[jsonParser objectWithString:jsonString error:&error];
    if ([error localizedDescription]) {
        NSLog(@"Parties parsing failed with error: %@",[error localizedDescription]);
    } else {
        NSLog(@"Parties parsed successfuly");
    }
    
    self.parties = [KTParser parsePartiesFromTree:jsonObjects];
    
    [jsonParser release], jsonParser = nil;
    [jsonString release], jsonString = nil;

}

- (KTMember *)getMemberWithId:(int)memberId {
    if (self.members) {
        for (KTMember *member in self.members) {
            if (member.memberId == memberId) {
                return member;
            }
        }
    }
    NSLog(@"Couldn't find member with id %d",memberId);
    return nil;
}

- (NSArray *)getMembersOfGender:(MemberGender)gender {
    NSMutableArray *filteredArr = [[[NSMutableArray alloc] init] autorelease];
    for (KTMember *member in self.members) {
        if (member.gender == gender) {
            [filteredArr addObject:member];
        }
    }
    return filteredArr;
}

- (NSArray *)getAllMemberNames {
    if (self.members) {
        NSMutableArray *namesArr = [[[NSMutableArray alloc] init] autorelease];
        for (KTMember *member in self.members) {
            [namesArr addObject:member.name];
        }
        return namesArr;
    }
    return nil;
}

- (NSArray *)getMembersForParty:(NSString *)partyName {
    if (self.members) {
        NSMutableArray *membersArr = [[[NSMutableArray alloc] init] autorelease];
        for (KTMember *member in self.members) {
            if ([member.party isEqualToString:partyName]) {
                [membersArr addObject:member];
            }
        }
        return membersArr;
    }
    return nil;
}

- (NSArray *)getAllParties {
    if (self.members) {
        NSMutableSet *partiesSet = [[[NSMutableSet alloc] init] autorelease];
        for (KTMember *member in self.members) {
            [partiesSet addObject:member.party];
        }
        return [partiesSet allObjects];
    }
    return nil;
}

- (NSArray *)getAllPlacesOfBirth {
    if (self.members) {
        NSMutableSet *placesSet = [[[NSMutableSet alloc] init] autorelease];
        for (KTMember *member in self.members) {
            [placesSet addObject:member.placeOfBirth];
        }
        return [placesSet allObjects];
    }
    return nil;
}

- (NSArray *) getAllRolesForGender:(MemberGender)gender; {
    if (self.members) {
        NSMutableSet *rolesSet = [[[NSMutableSet alloc] init] autorelease];
        for (KTMember *member in self.members) {
            if (member.currentRoleDescriptions && (member.gender == gender)) {
                [rolesSet addObject:member.currentRoleDescriptions];
            }
        }
        return [rolesSet allObjects];
    }
    return nil;
}


- (NSArray *)getFourRandomMembersOfGender:(MemberGender)gender {
    
    if ([DataManager sharedManager].members) {
        NSArray *filteredMembers = [[DataManager sharedManager] getMembersOfGender:gender];
        int memberCount = [filteredMembers count];
        if (memberCount > 3) {
            int index1,index2,index3,index4,randIndex;
            NSMutableArray *randomArr = [[[NSMutableArray alloc] init] autorelease];            
            
            NSMutableArray *remainingOptionsArr = [[NSMutableArray alloc] init];
            for (int i = 0; i < memberCount; i++) {
                NSNumber *num = [NSNumber numberWithInt:i];
                [remainingOptionsArr addObject:num];
            }
            
            //Get random indexes
            randIndex = arc4random() % [remainingOptionsArr count];
            index1 = [[remainingOptionsArr objectAtIndex:randIndex] intValue];
            [remainingOptionsArr removeObjectAtIndex:randIndex];
            randIndex = arc4random() % [remainingOptionsArr count];
            index2 = [[remainingOptionsArr objectAtIndex:randIndex] intValue];
            [remainingOptionsArr removeObjectAtIndex:randIndex];
            randIndex = arc4random() % [remainingOptionsArr count];
            index3 = [[remainingOptionsArr objectAtIndex:randIndex] intValue];
            [remainingOptionsArr removeObjectAtIndex:randIndex];
            randIndex = arc4random() % [remainingOptionsArr count];
            index4 = [[remainingOptionsArr objectAtIndex:randIndex] intValue];
            [remainingOptionsArr removeObjectAtIndex:randIndex];
            
            //Add members from indexes
            [randomArr addObject:[filteredMembers objectAtIndex:index1]];
            [randomArr addObject:[filteredMembers objectAtIndex:index2]];
            [randomArr addObject:[filteredMembers objectAtIndex:index3]];
            [randomArr addObject:[filteredMembers objectAtIndex:index4]];
            
            return randomArr;
        } else {
            NSLog(@"Error - Not enough members!");
        }
    }
    return nil;
}

- (KTMember *) getRandomMember {
    int memberCount = [[DataManager sharedManager].members count];
    int randIndex = arc4random() % memberCount;
    return [[DataManager sharedManager].members objectAtIndex:randIndex];
}

- (KTMember *) getRandomMemberWithRole {
    NSArray *membersWithRole = [[DataManager sharedManager] getMembersWithRole];
    int memberCount = membersWithRole.count;
    int randIndex = arc4random() % memberCount;
    return [membersWithRole objectAtIndex:randIndex];
}

- (int)getAgeForMember:(KTMember *)member {
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar] 
                                       components:NSYearCalendarUnit 
                                       fromDate:member.dateOfBirth
                                       toDate:now
                                       options:0];
    return [ageComponents year];;
}

- (int) getPartyIdForName:(NSString *)partyName {
    for (KTParty *party in self.parties) {
        if ([party.name isEqualToString:partyName]) {
            return party.partyId;
        }
    }
    return -1;
}

#pragma mark - Image Caching

- (UIImage *)getImageForMemberId:(int)memberId {
    UIImage *memberImg = [UIImage imageNamed:[NSString stringWithFormat:@"%d",memberId]];
    if (memberImg) {
        return memberImg;
    } else {
        memberImg = [[DataManager sharedManager] savedImageForId:memberId];
    }
    
    if (memberImg) {
        return memberImg;
    } else {
        KTMember *member = [[DataManager sharedManager] getMemberWithId:memberId];
        if (member) {
            NSLog(@"caching member %d locally",member.memberId);
            memberImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:member.imageUrl]]];
            [[DataManager sharedManager] saveImageToTempDirectory:memberImg withId:memberId];
            return memberImg;
        } else {
            return nil;
        }
    }
}

- (UIImage *)savedImageForId:(int)imageId {
    NSString *tempDir = NSTemporaryDirectory();
    NSString *filePath = [tempDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",imageId]];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    return img;
}

- (void) saveImageToTempDirectory:(UIImage *)image withId:(int)imageId {
        NSString *tempDir = NSTemporaryDirectory();
        NSString *filePath = [tempDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",imageId]];
        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
}

- (void) saveAllImagesLocally {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (KTMember *member in self.members) {
        [self getImageForMemberId:member.memberId];
    }
    [pool release];
}

#pragma mark - Public (Updates)
- (void)updateMemberData:(NSData *)newMemberData andPartyData:(NSData *)newPartyData andBillsData:(NSData *)newBillsData {
    [newMemberData retain];
    [newPartyData retain];
    [newBillsData retain];
    
    //Write member data
    NSString *pathForMemberFile = [DataManager pathForStoringUpdateDataForResourceType:kResourceTypeMember];
    [newMemberData writeToFile:pathForMemberFile atomically:YES];
    
    //Write party data
    NSString *pathForPartyFile = [DataManager pathForStoringUpdateDataForResourceType:kResourceTypeParty];
    [newPartyData writeToFile:pathForPartyFile atomically:YES];
    
    //Write bills data
    NSString *pathForBillsFile = [DataManager pathForStoringUpdateDataForResourceType:kResourceTypeBills];
    [newBillsData writeToFile:pathForBillsFile atomically:YES];
    
    [self initializeMembers];
    [self initializeParties];
    
    [newMemberData release];
    [newPartyData release];
    [newBillsData release];
    
    NSDate *lastUpdateTime = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdateTime forKey:kUpdateTimeUserDefaultsKey];
}

- (BOOL)isTimeForUpdate {
    NSDate *lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:kUpdateTimeUserDefaultsKey];
    if (!lastUpdateTime) {
        return YES;
    }
    
    NSDate *now = [NSDate date];
    NSTimeInterval timeDiff = [now timeIntervalSinceDate:lastUpdateTime];
    if (timeDiff > kTimeIntervalToUpdate) {
        return YES;
    }
    return NO;
}

@end
