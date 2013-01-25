//
//  UpdateDelegateProtocol.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 1/25/13.
//
//

#import <Foundation/Foundation.h>

@protocol UpdateDelegate <NSObject>

- (void)updateDownloadCompleteWithMemberData:(NSData *)memberData andPartyData:(NSData *)partyData andBillsData:(NSData *)billsData;
- (void)updateDownloadFailed;

@end
