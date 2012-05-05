//
//  KTParser.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//   
//

#import <Foundation/Foundation.h>

@interface KTParser : NSObject

+ (NSArray *)parseBillsArrayFromTree:(NSArray *)billsTree;
+ (NSArray *)parseCommitteesArrayFromTree:(NSArray *)committeeTree;
+ (NSArray *)parseMemberLinksFromTree:(NSArray *)linksTree;
+ (NSArray *)parseMembersFromTree:(NSArray *)membersTree;
+ (NSArray *)parseBillsFromTree:(NSArray *)billsTree;

@end
