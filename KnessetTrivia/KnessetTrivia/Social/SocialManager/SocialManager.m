//
//  SocialManager.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 12/7/12.
//  Copyright (c) 2012 Stav Ashuri. All rights reserved.
//

#import "SocialManager.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "Facebook.h"


#define kFacebookPermissionsEmail @"email"
#define kFacebookPermissionsUserAboutMe @"user_about_me"
#define kFacebookPermissionsFriendsAboutMe @"friends_about_me"
#define kFacebookPermissionsPublishAction @"publish_actions"

#define kFacebookPostParamLink          @"link"
#define kFacebookPostParamPictureUrl    @"picture"
#define kFacebookPostParamName          @"name"
#define kFacebookPostParamCaption       @"caption"
#define kFacebookPostParamDescription   @"description"
#define kFacebookPostParamMessage       @"message"
#define kFacebookFeedDialogParamName @"name"
#define kFacebookFeedDialogParamCaption @"caption"
#define kFacebookFeedDialogParamDescription @"description"
#define kFacebookFeedDialogParamLink @"link"
#define kFacebookFeedDialogParamPicture @"picture"
#define kFacebookFeedDialogParamTo @"to"
#define kFacebookFeedDialogName @"feed"
#define kFacebookFeedDialogAppId @"app_id"

#define kFacebookSDKJsonResponseKey @"com.facebook.sdk:ParsedJSONResponseKey"

#define kFacebookSDKErrorCodeOAuthError 190
#define kFacebookSDKErrorSubcodeAppNotInstalled 458
#define kFacebookSDKErrorSubcodeUserCheckpointed 459
#define kFacebookSDKErrorSubcodePasswordChanged 460
#define kFacebookSDKErrorSubcodeExpired 463
#define kFacebookSDKErrorSubcodeUnconfirmedUser 464
#define kFacebookErrorUserInfoKeyBody    @"body"
#define kFacebookErrorUserInfoKeyError   @"error"
#define kFacebookErrorUserInfoKeyCode    @"code"
#define kFacebookErrorUserInfoKeySubCode @"error_subcode"

NSString *const FBSessionStateChangedNotification = @"org.oknesset.trivia:FBSessionStateChangedNotification";

@interface SocialManager() <FBDialogDelegate>

@property (strong, nonatomic) Facebook *facebook;
@property (copy, nonatomic) FacebookFailBlock pendingFacebookPostFailBlock;
@property (copy, nonatomic) FacebookPostCompletionBlock pendingFacebookPostCompletionBlock;

@end

@implementation SocialManager

#pragma mark - Shared Instance

+ (id)sharedManager;
{
    static dispatch_once_t onceToken;
    static SocialManager *sharedManager = nil;
    
    dispatch_once( &onceToken, ^{
        sharedManager = [[SocialManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - NSObject

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(sessionStateChanged:)
         name:FBSessionStateChangedNotification
         object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark - Session Changes

- (void)sessionStateChanged:(NSNotification*)notification {

    if (FBSession.activeSession.isOpen) {
        NSLog(@"Detected session change: is open");
    } else {
        NSLog(@"Detected session change: is closed");
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

#pragma mark - Private

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[[NSArray alloc] initWithObjects:nil] autorelease];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI completionHandler:(FBSessionStateHandler)completion{
    NSArray *permissions = [[[NSArray alloc] initWithObjects:nil] autorelease];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:completion];
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)publishToFeedWithParams:(NSDictionary *)params withCompletionBlock:(FacebookPostCompletionBlock)completionBlock andFailBlock:(FacebookFailBlock)failBlock {
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:params
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         if (error.code) {
             failBlock([[error userInfo] description]);
         } else {
             completionBlock();
         }
     }];
}

- (FacebookFriend *)facebookFriendFromGraphObject:(id<FBGraphObject>)obj {
    FacebookFriend *friend = [[[FacebookFriend alloc] init] autorelease];
    friend.name = [obj objectForKey:@"name"];
    friend.imageUrl = [obj objectForKey:@"pic_square"];
    friend.uid = [obj objectForKey:@"uid"];
    return friend;
}

#pragma mark - Public

- (NSString *)getFacebookTokenFromActiveSession {
    FBSession *activeSession = [FBSession activeSession];
    if (activeSession.accessToken) {
        return activeSession.accessToken;
    } else {
        NSLog(@"Couldn't obtain access token");
        return nil;
    }
}

- (void)getFullNameFromActiveSessionWithCompletion:(FacebookFullNameCompletionBlock)successBlock onFailure:(FacebookFailBlock)failBlock {    
    FBSessionStateHandler handler = ^(FBSession *session,
                                      FBSessionState state,
                                      NSError *error) {
        if (error) {
            NSLog(@"Can't obtain access token");
            failBlock([error localizedDescription]);
        } else {
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id <FBGraphUser> result, NSError *error) {
                if (error) {
                    if (!error.code == 5) {
                        NSLog(@"Error - Can't query user information");
                        failBlock([[error userInfo] description]);
                    }
                } else {
                    NSString *firstName = [result first_name];
                    NSString *lastName = [result last_name];
                    successBlock([NSString stringWithFormat:@"%@ %@",firstName,lastName]);
                }
            }];
        }
    };
    
    [self openSessionWithAllowLoginUI:NO completionHandler:handler];
}

- (void)facebookLoginWithCompletion:(FacebookLoginSuccessBlock)successBlock onFailure:(FacebookFailBlock)failBlock{

        if (FBSession.activeSession.isOpen) {
            [self closeSession];
        }
        
        FBSessionStateHandler handler = ^(FBSession *session,
                                          FBSessionState state,
                                          NSError *error) {
            if (error) {
                NSLog(@"Can't obtain access token");
                failBlock([[error userInfo] description]);
            } else {
                NSLog(@"Obtaining facebook user information...");
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id <FBGraphUser> result, NSError *error) {
                    if (error) {
                        if (!error.code == 5) {
                            NSLog(@"Can't query user information");
                            failBlock([[error userInfo] description]);
                        } else {
                            NSDictionary *userInfo = [error userInfo];
                            NSDictionary *parsedJSON = [userInfo objectForKey:kFacebookSDKJsonResponseKey];
                            NSDictionary *body = [parsedJSON objectForKey:kFacebookErrorUserInfoKeyBody];
                            NSDictionary *bodyError = [body objectForKey:kFacebookErrorUserInfoKeyError];
                            int code = [[bodyError objectForKey:kFacebookErrorUserInfoKeyCode] intValue];
                            int subcode = [[bodyError objectForKey:kFacebookErrorUserInfoKeySubCode] intValue];
                            if (code == kFacebookSDKErrorCodeOAuthError && subcode == kFacebookSDKErrorSubcodeAppNotInstalled) {
                                failBlock(@"Please authorize the application on Facebook");
                            }
                        }
                    } else {
                        NSString *firstName = [result first_name];
                        NSString *lastName = [result last_name];
                        NSString *username = [result username];
                        successBlock(session.accessToken, firstName, lastName, username);
                    }
                }];
            }
        };
        
        [self openSessionWithAllowLoginUI:YES completionHandler:handler];

}

- (void)postToFacebookWithLink:(NSString *)link andPictureURL:(NSString *)picUrl andName:(NSString *)name andCaption:(NSString *)caption andDescription:(NSString *)description andMessage:(NSString *)message onCompletion:(FacebookPostCompletionBlock)completionBlock onFailure:(FacebookFailBlock)failBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (link.length) {
        [params setObject:link forKey:kFacebookPostParamLink];
    }
    
    if (picUrl.length) {
        [params setObject:picUrl forKey:kFacebookPostParamPictureUrl];
    }
    
    if (name.length) {
        [params setObject:name forKey:kFacebookPostParamName];
    }
    
    if (caption.length) {
        [params setObject:caption forKey:kFacebookPostParamCaption];
    }
    
    if (description.length) {
        [params setObject:description forKey:kFacebookPostParamDescription];
    }
    
    if (message.length) {
        [params setObject:message forKey:kFacebookPostParamMessage];
    }
    
    [FBSession openActiveSessionWithAllowLoginUI:NO];

    if ([FBSession.activeSession.permissions indexOfObject:kFacebookPermissionsPublishAction] == NSNotFound) {
        [FBSession.activeSession
         reauthorizeWithPublishPermissions:
         [NSArray arrayWithObject:kFacebookPermissionsPublishAction]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 [self publishToFeedWithParams:params withCompletionBlock:completionBlock andFailBlock:failBlock];
             } else {
                 failBlock([[error userInfo] description]);
             }
         }];
    } else {
        [self publishToFeedWithParams:params withCompletionBlock:completionBlock andFailBlock:failBlock];
    }
}

- (void)postToFacebookWithFeedDialogWithPostName:(NSString *)name andCaption:(NSString *)caption andDescription:(NSString *)description andLink:(NSString *)link andPictureUrl:(NSString *)pictureUrl onCompletion:(FacebookPostCompletionBlock)completionBlock onFailure:(FacebookFailBlock)failBlock{
        
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (name.length) {
        [params setObject:name forKey:kFacebookFeedDialogParamName];
    }
    
    if (caption.length) {
        [params setObject:caption forKey:kFacebookFeedDialogParamCaption];
    }
    
    if (description.length) {
        [params setObject:description forKey:kFacebookFeedDialogParamDescription];
    }
    
    if (link.length) {
        [params setObject:link forKey:kFacebookFeedDialogParamLink];
    }
    
    if (pictureUrl.length) {
        [params setObject:pictureUrl forKey:kFacebookFeedDialogParamPicture];
    }
        
    self.pendingFacebookPostCompletionBlock = completionBlock;
    self.pendingFacebookPostFailBlock = failBlock;

    if (!self.facebook) {
        self.facebook = [[Facebook alloc]
                         initWithAppId:FBSession.activeSession.appID
                         andDelegate:nil];
        self.facebook.accessToken = FBSession.activeSession.accessToken;
        self.facebook.expirationDate = FBSession.activeSession.expirationDate;
    }
    
    [self.facebook dialog:kFacebookFeedDialogName andParams:params andDelegate:self];
}

- (void)postToFacebookWithNativeShareDialogFromViewController:(UIViewController *)sender withInitialText:(NSString *)initialText withImageName:(NSString *)imageName andUrl:(NSString *)url onCompletion:(FacebookNativePostCompletionBlock)completionBlock onFailure:(FacebookFailBlock)failBlock{
    BOOL displayedNativeDialog =
        [FBNativeDialogs
         presentShareDialogModallyFrom:sender
         initialText:initialText
         image:[UIImage imageNamed:imageName]
         url:[NSURL URLWithString:url]
         handler:^(FBNativeDialogResult result, NSError *error) {
             if (error) {
                 failBlock([[error userInfo] description]);
             } else {
                 if (result == FBNativeDialogResultSucceeded) {
                     completionBlock();
                 } else {
                     failBlock(@"User cancelled");
                 }
             }
         }];
    if (!displayedNativeDialog) {
        failBlock(@"Native dialog is not supported");
    }
}

-(void) dialogCompleteWithUrl:(NSURL *)url {
    NSString *urlString    = url.absoluteString;
    static NSString *postIdString = @"?post_id=";
    
    if ([urlString rangeOfString:postIdString].location == NSNotFound) {
        if (self.pendingFacebookPostFailBlock) {
            self.pendingFacebookPostFailBlock(@"Operation cancelled by user");
            self.pendingFacebookPostFailBlock = nil;
        }
    } else {
        if (self.pendingFacebookPostCompletionBlock) {
            self.pendingFacebookPostCompletionBlock();
            self.pendingFacebookPostCompletionBlock = nil;
        }
    }
    
    self.facebook = nil;
}


@end
