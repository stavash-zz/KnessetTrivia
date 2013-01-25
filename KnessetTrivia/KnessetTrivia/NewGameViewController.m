//
//  NewGameViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/3/12.
//   
//
#import "NewGameViewController.h"
#import "SocialManager.h"
#import "UpdateViewController.h"
#import "DataManager.h"

#define kNewGameStartPhraseFirst @"לחץ כדי להתחיל במשחק"
#define kNewGameStartPhrase1 @"מוכנים לעוד אחד?"
#define kNewGameStartPhrase2 @"הגיע הזמן לשבור את השיא..."
#define kNewGameStartPhrase3 @"חושבים שאתם מבינים בענייני כנסת?"
#define kNewGameStartPhrase4 @"הפעם בלי טעויות..."
#define kNewGameStartPhrase5 @"רוצים עוד קצת?"
#define kNewGameFirstGameEverDefaultsKey @"firstGameEver"

@interface NewGameViewController () {
    dispatch_queue_t backgroundQueue;
}

@property (retain, nonatomic) UpdateViewController *updateController;

@end

@implementation NewGameViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    backgroundQueue = dispatch_queue_create("org.oknesset.trivia", NULL);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookPreferenceChanged) name:kFacebookPreferenceChangedNotification object:nil];
    
    BOOL isFacebookConnected = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsIsFacebookConnectedKey] boolValue];
    if (isFacebookConnected) {
        [[SocialManager sharedManager] facebookLoginWithCompletion:^(NSString *token, NSString *firstName, NSString *lastName, NSString *username) {
            facebookButton.alpha = 0.0;
            [self displayFacebookNameIfAvailable];
        } onFailure:^(NSString *errorDescription) {
            facebookButton.alpha = 1.0;
        }];
    } else {
        facebookButton.alpha = 1.0;
    }
    
    NSString *startPhrase;
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:kNewGameFirstGameEverDefaultsKey];
    
    if (!num) {
        firstGameEver = YES;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kNewGameFirstGameEverDefaultsKey];
    } else {
        firstGameEver = NO;
    }
    
    if (firstGameEver) {
        startPhrase = kNewGameStartPhraseFirst;
    } else {
        StartPhrase randomPhrase = arc4random() % startPhraseCount;
        switch (randomPhrase) {
            case kStartPhrase1:
                startPhrase = kNewGameStartPhrase1;
                break;
            case kStartPhrase2:
                startPhrase = kNewGameStartPhrase2;
                break;
            case kStartPhrase3:
                startPhrase = kNewGameStartPhrase3;
                break;
            case kStartPhrase4:
                startPhrase = kNewGameStartPhrase4;
                break;
            case kStartPhrase5:
                startPhrase = kNewGameStartPhrase5;
                break;
            default:
                break;
        }
    }
    startPhraseLabel.text = startPhrase;
    
    if ([[DataManager sharedManager] isTimeForUpdate]) {
        UpdateViewController *updateVC = [[UpdateViewController alloc] initWithNibName:@"UpdateViewController" bundle:nil];
        updateVC.delegate = self;
        [self.view addSubview:updateVC.view];
        self.updateController = updateVC;
        [updateVC release];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private

- (void)facebookPreferenceChanged {
    BOOL isFacebookConnected = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsIsFacebookConnectedKey] boolValue];
    if (!isFacebookConnected) {
        facebookButton.alpha = 1.0;
        welcomeLabel.alpha = 0.0;
    } else {
        facebookButton.alpha = 1.0;
        welcomeLabel.alpha = 0.0;
    }
}

- (void)displayFacebookNameIfAvailable {
    [[SocialManager sharedManager] getFullNameFromActiveSessionWithCompletion:^(NSString *fullName) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{
                facebookButton.alpha = 0.0;
                welcomeLabel.text = [NSString stringWithFormat:@"ברוכים הבאים, %@",fullName];
                welcomeLabel.alpha = 1.0;
            }];
        });
    } onFailure:^(NSString *errorDescription) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{
                facebookButton.alpha = 1.0;
                welcomeLabel.alpha = 0.0;
            }];
        });
    }];
}

#pragma mark - Animations

- (void) animationStopped {
    [self.view removeFromSuperview];
}

- (void) closeAnimated {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStopped)];
    self.view.alpha = 0;
    [UIView commitAnimations];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - IBActions

- (IBAction)startGamePressed:(id)sender {
    [self.delegate newGameRequested];
    [self closeAnimated];
}

- (IBAction)signInWithFacebookPressed:(id)sender {
    [[SocialManager sharedManager] facebookLoginWithCompletion:^(NSString *token, NSString *firstName, NSString *lastName, NSString *username) {
        NSLog(@"Log in success!");
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{
                welcomeLabel.alpha = 1.0;
                facebookButton.alpha = 0.0;
            }];
            welcomeLabel.text = [NSString stringWithFormat:@"ברוכים הבאים, %@ %@",firstName, lastName];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kUserDefaultsIsFacebookConnectedKey];
        });
    } onFailure:^(NSString *errorDescription) {
        NSLog(@"Couldn't log in to Facebook: %@",errorDescription);
    }];
}

#pragma mark - UpdateDelegate

- (void)updateDownloadCompleteWithMemberData:(NSData *)memberData andPartyData:(NSData *)partyData andBillsData:(NSData *)billsData {
    [[DataManager sharedManager] updateMemberData:memberData andPartyData:partyData andBillsData:billsData];
    [self.updateController.view removeFromSuperview];
}

- (void)updateDownloadFailed {
   [self.updateController.view removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"עדכון נתונים" message:@"עדכון הנתונים נכשל" delegate:self cancelButtonTitle:@"אישור" otherButtonTitles: nil];
    [alert show];
    [alert release];
    NSLog(@"update failed");
}

@end
