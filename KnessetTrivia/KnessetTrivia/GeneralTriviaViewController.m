//
//  GeneralTriviaViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GeneralTriviaViewController.h"
#import "DataManager.h"

@interface GeneralTriviaViewController ()

@end

@implementation GeneralTriviaViewController
@synthesize scoreLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"טריוויה";
        self.tabBarItem.image = [UIImage imageNamed:@"TriviaTab"];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 372, 286, 21)];
    [newLabel setBackgroundColor:[UIColor clearColor]];
    [newLabel setTextAlignment:UITextAlignmentRight];
    self.scoreLabel = newLabel;
    [self.view addSubview:self.scoreLabel];
    [newLabel release];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScoreLabel) name:@"scoreUpdatedNotification" object:nil];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.scoreLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) updateScoreLabel {
    scoreLabel.text = [NSString stringWithFormat:@"ניקוד: %@",[[DataManager sharedManager] getCurrentScoreStr]];
}

@end
