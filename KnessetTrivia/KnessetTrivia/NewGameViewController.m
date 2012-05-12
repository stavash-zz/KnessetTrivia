//
//  NewGameViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/3/12.
//   
//

#import "NewGameViewController.h"

#define kNewGameStartPhraseFirst @"לחץ כדי להתחיל במשחק"
#define kNewGameStartPhrase1 @"מוכנים לעוד אחד?"
#define kNewGameStartPhrase2 @"הגיע הזמן לשבור את השיא..."
#define kNewGameStartPhrase3 @"חושבים שאתם מבינים בענייני כנסת?"
#define kNewGameStartPhrase4 @"הפעם בלי טעויות..."
#define kNewGameStartPhrase5 @"רוצים עוד קצת?"
#define kNewGameFirstGameEverDefaultsKey @"firstGameEver"

@interface NewGameViewController ()

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
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

@end
