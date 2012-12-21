//
//  AboutViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/28/12.
//   
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ScoreManager.h"
#import "GoogleAnalyticsLogger.h"
#import "SoundEngine.h"
#import "SocialManager.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"אודות";
        self.tabBarItem.image = [UIImage imageNamed:@"AboutTab"];
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [self updateHighScore];
    [soundSwitch setOn:[[SoundEngine sharedSoundEngine] getSoundState] animated:YES];
}

- (void)viewDidLoad
{
    descriptionLabel.text = @"חלק מפרוייקט \"כנסת פתוחה\"\nבשיתוף אוניברסיטת תל אביב";
    CALayer *l = [highScoreBg layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    highScoreLabel.layer.shadowColor = [UIColor yellowColor].CGColor;
    highScoreLabel.layer.shadowOffset = CGSizeMake(0, 0);
    highScoreLabel.layer.shadowOpacity = 1.0;
    highScoreLabel.layer.shadowRadius = 5.0;
    highScoreLabel.clipsToBounds = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHighScore) name:kScoreManagerNotificationHighscoreUpdated object:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Notification Handlers 
- (void) updateHighScore {
    highScoreLabel.text = [NSString stringWithFormat:@"%d",[[ScoreManager sharedManager] getHighScore]];
    
}

#pragma mark - IBActions
- (IBAction)goToOpenKnessetPressed:(id)sender {
    [[GoogleAnalyticsLogger sharedLogger] logSiteLinkPressed:kSiteLinkOpenKnesset];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://oknesset.org/"]];
}

- (IBAction)goToYedaPressed:(id)sender {
    [[GoogleAnalyticsLogger sharedLogger] logSiteLinkPressed:kSiteLinkPublicKnowledge];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://hasadna.org.il/"]]; 
}

- (IBAction)soundSwitchChanged:(id)sender {
    UISwitch *sSwitch = (UISwitch *)sender;
    [[SoundEngine sharedSoundEngine] setSoundON:sSwitch.on];
}

- (IBAction)logOut:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kUserDefaultsIsFacebookConnectedKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFacebookPreferenceChangedNotification object:nil];
}


@end
