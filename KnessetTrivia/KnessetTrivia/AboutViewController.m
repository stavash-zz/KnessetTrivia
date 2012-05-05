//
//  AboutViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/28/12.
//   
//

#import "AboutViewController.h"
#import "ScoreManager.h"
#import <QuartzCore/QuartzCore.h>

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
}

- (void)viewDidLoad
{
    CALayer *l = [highScoreBg layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHighScore) name:@"highScoreUpdatedNotification" object:nil];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://oknesset.org/"]];
}

- (IBAction)goToYedaPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://yeda.us/"]]; 
}


@end
