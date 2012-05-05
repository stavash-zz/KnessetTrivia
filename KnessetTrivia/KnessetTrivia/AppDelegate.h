//
//  AppDelegate.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/1/12.
//   
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {
    int secondsElapsed;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, retain) NSTimer *gameTimer;

@end
