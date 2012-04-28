//
//  KTDataManager.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTDataManager.h"
#import "SBJsonParser.h"
#import "KTParser.h"
#import "KTMember.h"

@implementation KTDataManager
@synthesize members;

static KTDataManager *manager = nil;

#pragma mark - Default

+ (KTDataManager *) sharedManager {
	@synchronized(self) {
		if (!manager) {
			[[KTDataManager alloc] init];
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
    [super dealloc];
}

#pragma mark - Default

- (void) initializeMembers {
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
    
    self.members = [KTParser parseMembersFromTree:jsonObjects];
    
    [jsonParser release], jsonParser = nil;

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

@end
