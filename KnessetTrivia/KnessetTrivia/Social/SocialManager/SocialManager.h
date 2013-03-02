//
//  SocialManager.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 12/7/12.
//  Copyright (c) 2012 Stav Ashuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookFriend.h"

#define kUserDefaultsIsFacebookConnectedKey @"isFacebookConnected"
#define kFacebookPreferenceChangedNotification @"FacebookPreferenceChanged"
typedef void (^FacebookLoginSuccessBlock)(NSString *token, NSString *firstName, NSString *lastName, NSString *username);
typedef void (^FacebookFriendsSuccessBlock)(NSArray *arrayOfFriends);
typedef void (^FacebookPostCompletionBlock)(void);
typedef void (^FacebookNativePostCompletionBlock)(void);
typedef void (^FacebookFullNameCompletionBlock)(NSString *fullName);
typedef void (^FacebookFailBlock)(NSString *errorDescription);

extern NSString *const FBSessionStateChangedNotification;

@interface SocialManager : NSObject

+ (id)sharedManager;

- (NSString *)getFacebookTokenFromActiveSession;
- (void)getFullNameFromActiveSessionWithCompletion:(FacebookFullNameCompletionBlock)successBlock onFailure:(FacebookFailBlock)failBlock;
- (void)facebookLoginWithCompletion:(FacebookLoginSuccessBlock)successBlock onFailure:(FacebookFailBlock)failBlock;
- (void)postToFacebookWithLink:(NSString *)link andPictureURL:(NSString *)picUrl andName:(NSString *)name andCaption:(NSString *)caption andDescription:(NSString *)description andMessage:(NSString *)message onCompletion:(FacebookPostCompletionBlock)completionBlock onFailure:(FacebookFailBlock)failBlock;
- (void)postToFacebookWithFeedDialogWithPostName:(NSString *)name andCaption:(NSString *)caption andDescription:(NSString *)description andLink:(NSString *)link andPictureUrl:(NSString *)pictureUrl onCompletion:(FacebookPostCompletionBlock)completionBlock onFailure:(FacebookFailBlock)failBlock;
- (void)postToFacebookWithNativeShareDialogFromViewController:(UIViewController *)sender withInitialText:(NSString *)initialText withImageName:(NSString *)imageName andUrl:(NSString *)url onCompletion:(FacebookNativePostCompletionBlock)completionBlock onFailure:(FacebookFailBlock)failBlock;

@end
