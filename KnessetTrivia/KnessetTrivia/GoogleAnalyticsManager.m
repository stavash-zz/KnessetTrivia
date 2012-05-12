//
//  GoogleAnalyticsManager.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 2/2/12.
//

#import "GoogleAnalyticsManager.h"

#define kGoogleAnalyticsDispatchPeriod 60

@implementation GoogleAnalyticsManager

#pragma initialization
static GoogleAnalyticsManager *sharedSingleton;

+ (GoogleAnalyticsManager *)sharedGoogleAnalyticsManager
{
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[GoogleAnalyticsManager alloc] init];
        }
        return sharedSingleton;
    }
}

- (id)init {
	self = [super init];
	if (self != nil) {

    }
    
	return self;
}

#pragma mark - Analytics Interface

- (void)setAnalyticsTrackingNumber:(NSString *)trackingNum {
    if (trackingNumberSet) {
        NSLog(@"*** Google Analytics Error ***\nAnalytics number already set");
    }
    [[GANTracker sharedTracker] startTrackerWithAccountID:trackingNum dispatchPeriod:kGoogleAnalyticsDispatchPeriod delegate:self];
    trackingNumberSet = YES;
}

- (void)sendGoogleAnalyticsTrackPageForTab:(NSString *)tabName {
    if (!trackingNumberSet) {
        NSLog(@"*** Google Analytics Error ***\nNo tracking number set for GoogleAnalyticsManager");
        return;
    }
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:tabName
                                    withError:&error]) {
        // Error Handling
    }
}

- (void)sendGoogleAnalyticsTrackEventCategory:(NSString *)eventCategory withEventName:(NSString *)eventName {
    if (!trackingNumberSet) {
        NSLog(@"*** Google Analytics Error ***\nNo tracking number set for GoogleAnalyticsManager");
        return;
    }
    
    NSError *err;
    if (![[GANTracker sharedTracker] trackEvent:eventCategory
                                    action:eventName
                                     label:nil
                                     value:-1
                                 withError:&err]) {        
    }
}

- (void)sendGoogleAnalyticsTrackEventCategory:(NSString *)eventCategory withEventName:(NSString *)eventName andLabel:(NSString *)aLabel withValue:(NSInteger)aValue {
    if (!trackingNumberSet) {
        NSLog(@"*** Google Analytics Error ***\nNo tracking number set for GoogleAnalyticsManager");
        return;
    }
    
    NSError *err;
    if (![[GANTracker sharedTracker] trackEvent:eventCategory
                                         action:eventName
                                          label:aLabel
                                          value:aValue
                                      withError:&err]) {        
    }
}



#pragma mark - GANTrackerDelegate

- (void)hitDispatched:(NSString *)hitString{
    NSLog(@"hitDispatched: %@",hitString);
}

- (void)trackerDispatchDidComplete:(GANTracker *)tracker
                  eventsDispatched:(NSUInteger)hitsDispatched
              eventsFailedDispatch:(NSUInteger)hitsFailedDispatch {
    NSLog(@"Succesfuly dispatched %u events out of %u",hitsDispatched,hitsDispatched+hitsFailedDispatch);
}

@end
