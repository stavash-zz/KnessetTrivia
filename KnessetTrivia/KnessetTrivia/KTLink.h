//
//  KTLink.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//   
//

#import <Foundation/Foundation.h>

@interface KTLink : NSObject {//TODO: inherit from superclass with url property
    NSString *linkDescription;
    NSString *url;
}

@property (nonatomic, retain) NSString *linkDescription;
@property (nonatomic, retain) NSString *url;

@end
