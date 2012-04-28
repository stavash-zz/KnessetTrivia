//
//  FirstViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "KTDataManager.h"
#import "KTMember.h"
#import "MemberCell.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize myMemberCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"אודות";
        self.tabBarItem.image = [UIImage imageNamed:@"AboutTab"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [[KTDataManager sharedManager] initializeMembers];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    self.myMemberCell = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.myMemberCell) {
        [self.myMemberCell.view removeFromSuperview];
        self.myMemberCell = nil;
    }
    KTMember *member = [[KTDataManager sharedManager].members objectAtIndex:indexPath.row];
    MemberCell *memberCell = [[MemberCell alloc] init];
    memberCell.member = member;
    CGRect cellFrame = memberCell.view.frame;
    memberCell.view.frame = CGRectMake((320-cellFrame.size.width)/2, (480-44-cellFrame.size.height)/2, cellFrame.size.width, cellFrame.size.height);
    self.myMemberCell = memberCell;
    [self.view addSubview:memberCell.view];
    [memberCell release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTMember *member = [[KTDataManager sharedManager].members objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }
    cell.textLabel.text = member.name;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[KTDataManager sharedManager].members count];
}

@end
