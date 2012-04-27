//
//  KTLink.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTLink : NSObject {
    NSString *linkDescription;
    NSString *url;
}

@property (nonatomic, retain) NSString *linkDescription;
@property (nonatomic, retain) NSString *url;

@end
