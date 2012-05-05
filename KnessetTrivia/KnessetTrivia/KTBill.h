//
//  KTBill.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/29/12.
//   
//

#import <Foundation/Foundation.h>

@class KTComitteeMeetings;

@interface KTBill : NSObject {
    NSString *billTitle;
    KTComitteeMeetings *comitteeMeetings;
    NSString *popularName;
    NSDictionary *proposals;
    NSArray *proposingMks;
    NSDate *stageDate;
    NSString *stageText;
    NSString *url;
    NSDictionary *votes;
}

@property (nonatomic, retain) NSString *billTitle;
@property (nonatomic, retain) KTComitteeMeetings *comitteeMeetings;
@property (nonatomic, retain) NSString *popularName;
@property (nonatomic, retain) NSDictionary *proposals;
@property (nonatomic, retain) NSArray *proposingMks;
@property (nonatomic, retain) NSDate *stageDate;
@property (nonatomic, retain) NSString *stageText;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSDictionary *votes;

@end
