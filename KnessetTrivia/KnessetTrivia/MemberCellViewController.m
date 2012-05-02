//
//  MemberTableCell.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemberCellViewController.h"
#import "KTMember.h"
#import "KTLink.h"
#import "DataManager.h"
#import "SoundEngine.h"
#import "MemberCellFlipSideViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MemberCellViewController ()

@end

@implementation MemberCellViewController
@synthesize member,infoButton,flipSideVC,myResultState;

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.myResultState = kResultUnknown;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [aiv startAnimating];
    
    CALayer *l1 = [imgView layer];
    [l1 setMasksToBounds:YES];
    [l1 setCornerRadius:10.0];
    
    CALayer *l2 = [self.view layer];
    [l2 setMasksToBounds:YES];
    [l2 setCornerRadius:10.0];
    
    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    imgView.layer.shadowOffset = CGSizeMake(0, 4);
    imgView.layer.shadowOpacity = 0.6;
    imgView.layer.shadowRadius = 10.0;
    imgView.clipsToBounds = NO;
    
    [self performSelectorInBackground:@selector(loadImage) withObject:nil];
    
    nameLabel.text = self.member.name;   
    
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

#pragma mark - Async Image

- (void) completeImageLoading:(UIImage *)img {
    imgView.image = img;

    [UIView beginAnimations:@"" context:nil];
    imgView.alpha = 1;
    [UIView commitAnimations];

    [aiv stopAnimating];

}

- (void) loadImage {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    //Load image
    UIImage *memberImg = [[DataManager sharedManager] getImageForMemberId:self.member.memberId];
    
    //Perform UI actions on main thread
    [self performSelectorOnMainThread:@selector(completeImageLoading:) withObject:memberImg waitUntilDone:YES];
    
    [autoreleasePool release];
}

#pragma mark - IBAction

- (IBAction) close {
    [self.view removeFromSuperview];
}

- (IBAction)infoPressed:(id)sender {
    if (!self.flipSideVC) {
        MemberCellFlipSideViewController *flipSideCont = [[MemberCellFlipSideViewController alloc] initWithNibName:@"MemberCellFlipSideViewController" bundle:nil];
        flipSideCont.member = self.member;
        flipSideCont.delegate = self;
        flipSideCont.view.alpha = 0;
        self.flipSideVC = flipSideCont;
        [flipSideCont release];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
    [self.flipSideVC.view setAlpha:1];
    [self.view addSubview:self.flipSideVC.view];
    [UIView commitAnimations];
}

#pragma mark - FlipSideDelegate

- (void) flipSideDismiss {
    if (self.flipSideVC) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];  
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
        [self.view sendSubviewToBack:self.flipSideVC.view];
        [self.flipSideVC.view setAlpha:0];
        [UIView commitAnimations];
    }
}

#pragma mark - Public
- (void) showCorrectIndication {
    self.myResultState = kResultCorrect;
    CGAffineTransform t = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView beginAnimations:@"" context:nil];
    self.view.backgroundColor = [UIColor greenColor];
    self.view.transform = t;
    [UIView commitAnimations];
    [[SoundEngine sharedSoundEngine] play:kSoundCodeCorrectAnswer];
}

- (void) showWrongIndication {
    self.myResultState = kResultWrong;
    CGAffineTransform t = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView beginAnimations:@"" context:nil];
    self.view.backgroundColor = [UIColor redColor];
    self.view.transform = t;
    [UIView commitAnimations];
    
}

- (void)showInfoButton {
    [UIView beginAnimations:@"" context:nil];
    infoButton.alpha = 1;
    [UIView commitAnimations];
}

- (void)hideInfoButton {
    [UIView beginAnimations:@"" context:nil];
    infoButton.alpha = 0;
    [UIView commitAnimations];
}


@end
