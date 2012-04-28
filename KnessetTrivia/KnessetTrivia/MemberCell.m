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

    //Correct frame
//    CGRect imgFrame = imgView.frame;
//    imgFrame.size = memberImg.size;
//    imgView.frame = imgFrame;

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

@end
