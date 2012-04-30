//
//  KTDataManager.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "SBJsonParser.h"
#import "KTParser.h"
#import "KTMember.h"

#define kDataManagerScoreForCorrectImageAnswer 9
#define kDataManagerPenaltyForWrongImageAnswer 10

@implementation DataManager
@synthesize members;

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
        score = 0;
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - Public

- (void) initializeMembers {
    NSData *memberData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"member" ofType:@"txt"]];
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

#pragma mark - Scrore
- (void)updateCorrectImageAnswer {
    score += kDataManagerScoreForCorrectImageAnswer;
    NSLog(@"scrore: %d",score);
}

- (void) updateWrongImageAnswer {
    score -= kDataManagerPenaltyForWrongImageAnswer;
    NSLog(@"scrore: %d",score);
}

- (int) getCurrentScore {
    return score;
}

#pragma mark - Image Caching

- (UIImage *)savedImageForId:(int)imageId {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",imageId]];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    return img;
}

- (void) saveImageToDocuments:(UIImage *)image withId:(int)imageId {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",imageId]];
        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
}

@end
