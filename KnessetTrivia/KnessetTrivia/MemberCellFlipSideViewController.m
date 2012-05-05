//
//  MemberCellFlipSideViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/1/12.
//   
//

#import "MemberCellFlipSideViewController.h"
#import "KTMember.h"
#import "KTLink.h"
#import "AppDelegate.h"

@interface MemberCellFlipSideViewController ()

@end

@implementation MemberCellFlipSideViewController
@synthesize member,delegate,mailVC;

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
    memberNameLabel.text = self.member.name;
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

#pragma mark - IBActions

- (IBAction)linksPressed:(id)sender { 
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"קישורים" delegate:self cancelButtonTitle:@"ביטול" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (KTLink *link in self.member.links) {
        [actionsheet addButtonWithTitle:link.linkDescription];
    }
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionsheet release];
}

- (IBAction)placeOfBirthPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?ll=%f,%f",self.member.placeOfBirthLat,self.member.placeOfBirthLon]]];
}

- (IBAction)homePagePressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://oknesset.org/member/%d",self.member.memberId]]];
}

- (IBAction)emailPressed:(id)sender {
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
    mailer.mailComposeDelegate = self;
    mailer.navigationBar.tintColor = [UIColor colorWithRed:30.0/255.0 green:114.0/255.0 blue:215.0/255.0 alpha:1.0];
    [mailer setToRecipients:[NSArray arrayWithObject:self.member.email]];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabBarController presentModalViewController:mailer animated:YES];
    
    self.mailVC = mailer;
    [mailer release];

}

- (IBAction)dismissPressed:(id)sender {
    [self.delegate flipSideDismiss];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self.mailVC dismissModalViewControllerAnimated:YES];
}


#pragma mark - UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {

    } else {
        KTLink *link = [self.member.links objectAtIndex:buttonIndex-1];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link.url]];
    }
}

@end
