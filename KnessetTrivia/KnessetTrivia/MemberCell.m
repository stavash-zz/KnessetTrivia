//
//  MemberTableCell.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemberCell.h"
#import "KTMember.h"
#import "KTLink.h"
#import <QuartzCore/QuartzCore.h>

@interface MemberCell ()

@end

@implementation MemberCell
@synthesize member;

#pragma mark - View Lifecycle

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
    [aiv startAnimating];
    
    CALayer *l1 = [imgView layer];
    [l1 setMasksToBounds:YES];
    [l1 setCornerRadius:10.0];
    
    CALayer *l2 = [self.view layer];
    [l2 setMasksToBounds:YES];
    [l2 setCornerRadius:10.0];
    
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

- (void) loadImage {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    //Load image
    UIImage *memberImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.member.imageUrl]]];
    imgView.image = memberImg;
   
    //Animate in
    [UIView beginAnimations:@"" context:nil];
    imgView.alpha = 1;
    [UIView commitAnimations];

    [aiv stopAnimating];
    
    [autoreleasePool release];
}

#pragma mark - UIActionSheetDelegate


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    } else {
        KTLink *link = [self.member.links objectAtIndex:buttonIndex-1];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link.url]];
    }
}

#pragma mark - IBAction

- (IBAction) close {
    [self.view removeFromSuperview];
}

- (IBAction) showLinks {
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"קישורים" delegate:self cancelButtonTitle:@"ביטול" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (KTLink *link in self.member.links) {
        [actionsheet addButtonWithTitle:link.linkDescription];
    }
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionsheet release];
}

#pragma mark - Public
- (void) showCorrectIndication {
    [UIView beginAnimations:@"" context:nil];
    self.view.backgroundColor = [UIColor greenColor];
    [UIView commitAnimations];
}

- (void) showWrongIndication {
    [UIView beginAnimations:@"" context:nil];
    self.view.backgroundColor = [UIColor redColor];
    [UIView commitAnimations];
    
}


@end
