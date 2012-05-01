//
//  ImageTriviaViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageTriviaViewController.h"
#import "DataManager.h"
#import "KTMember.h"
#import "MemberCellViewController.h"

#define kImageTriviaNextQuestionDelay 0.4

@interface ImageTriviaViewController ()

@end

@implementation ImageTriviaViewController
@synthesize topLeftMemberCell,topRightMemberCell,bottomLeftMemberCell,bottomRightMemberCell;
@synthesize optionsArr;

#pragma mark - Cell setters

- (void) setCell:(CellPosition)pos withMember:(KTMember *)member {
    MemberCellViewController *cellVC = [[MemberCellViewController alloc] initWithNibName:@"MemberCellViewController" bundle:nil];
    cellVC.member = member;

    switch (pos) {
        case kCellPositionTopLeft:
        {
            [topLeftView addSubview:cellVC.view];
            self.topLeftMemberCell = cellVC;            
        }
            break;
        case kCellPositionTopRight:
        {
            [topRightView addSubview:cellVC.view];
            self.topRightMemberCell = cellVC;
        }
            break;
        case kCellPositionBottomLeft:
        {
            [bottomLeftView addSubview:cellVC.view];
            self.bottomLeftMemberCell = cellVC;
        }
            break;
        case kCellPositionBottomRight:
        {
            [bottomRightView addSubview:cellVC.view];
            self.bottomRightMemberCell = cellVC;
        }
            break;
        default:
            break;
    }
    [cellVC release];

}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        correctIndex = -1;
    }
    return self;
}

- (void) loadNextQuestion {
        
    //clean up
    if (self.topLeftMemberCell) {
        [self.topLeftMemberCell.view removeFromSuperview];
    }
    if (self.topRightMemberCell) {
        [self.topRightMemberCell.view removeFromSuperview];
    }
    if (self.bottomRightMemberCell) {
        [self.bottomLeftMemberCell.view removeFromSuperview];
    }
    if (self.bottomRightMemberCell) {
        [self.bottomRightMemberCell.view removeFromSuperview];
    }
    self.topLeftMemberCell = nil;
    self.topRightMemberCell = nil;
    self.bottomLeftMemberCell = nil;
    self.bottomRightMemberCell = nil;
    
    //Populate question
    self.optionsArr = [[DataManager sharedManager] getFourRandomMembers];
    if (!self.optionsArr) {
        return;
    }
    
    correctIndex = arc4random() % 4;
    KTMember *correctMember = [self.optionsArr objectAtIndex:correctIndex];
    questionLabel.text = [NSString stringWithFormat:@"זהה את %@",correctMember.name];
    [self setCell:kCellPositionTopLeft withMember:[self.optionsArr objectAtIndex:0]];
    [self setCell:kCellPositionTopRight withMember:[self.optionsArr objectAtIndex:1]];
    [self setCell:kCellPositionBottomLeft withMember:[self.optionsArr objectAtIndex:2]];
    [self setCell:kCellPositionBottomRight withMember:[self.optionsArr objectAtIndex:3]];
    
    [self hideAllInfoButtons];

    [UIView beginAnimations:@"" context:nil];
    helpButton.alpha = 1;
    [UIView commitAnimations];
}

- (void) viewDidAppear:(BOOL)animated {    
//    [self loadNextQuestion];
}

- (void) viewDidDisappear:(BOOL)animated {

}

- (void)viewDidLoad
{
    UITapGestureRecognizer *tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topLeftViewTapped)];
    tapGR1.delegate = self;
    [topLeftView addGestureRecognizer:tapGR1];
    [tapGR1 release];

    UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topRightViewTapped)];
    tapGR2.delegate = self;
    [topRightView addGestureRecognizer:tapGR2];
    [tapGR2 release];
    
    UITapGestureRecognizer *tapGR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomLeftViewTapped)];
    tapGR3.delegate = self;
    [bottomLeftView addGestureRecognizer:tapGR3];
    [tapGR3 release];
    
    UITapGestureRecognizer *tapGR4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomRightViewTapped)];
    tapGR4.delegate = self;
    [bottomRightView addGestureRecognizer:tapGR4];
    [tapGR4 release];
    
    [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:0.5];
    
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

#pragma mark - Helper methods

- (KTMember *)getCorrectMember {
    if (self.optionsArr) {
        return [self.optionsArr objectAtIndex:correctIndex];
    }
    return nil;
}

- (void) changeInfoToVisible:(BOOL)visible {
    NSArray *cellArr = [NSArray arrayWithObjects:self.topLeftMemberCell,self.topRightMemberCell,self.bottomLeftMemberCell,self.bottomRightMemberCell, nil];
    for (MemberCellViewController *memberCell in cellArr) {
        if (visible) {
            [memberCell showInfoButton];
        } else {
            [memberCell hideInfoButton];
        }
    }
        
}

- (void) showAllInfoButtons {
    [self changeInfoToVisible:YES];
}

- (void) hideAllInfoButtons {
    [self changeInfoToVisible:NO];
}

#pragma mark - IBActions

- (IBAction)helpPressed:(id)sender{
    [self showAllInfoButtons];
    
    [UIView beginAnimations:@"" context:nil];
    helpButton.alpha = 0;
    [UIView commitAnimations];
    
    [[DataManager sharedManager] updateHelpRequested];
}

#pragma mark - Gesture handlers

- (BOOL)checkCorrectnessOfPosition:(CellPosition)pos {
    KTMember *correctMember = [self getCorrectMember];
    if (!correctMember) {
        return NO;
    }
    switch (pos) {
        case kCellPositionTopLeft:
            return (correctMember.memberId == topLeftMemberCell.member.memberId);
            break;
        case kCellPositionTopRight:
            return (correctMember.memberId == topRightMemberCell.member.memberId);
            break;
        case kCellPositionBottomLeft:
            return (correctMember.memberId == bottomLeftMemberCell.member.memberId);
            break;
        case kCellPositionBottomRight:
            return (correctMember.memberId == bottomRightMemberCell.member.memberId);
            break;
        default:
            break;
    }
}

- (void) topLeftViewTapped {
    if ([self checkCorrectnessOfPosition:kCellPositionTopLeft]) {
        [self.topLeftMemberCell showCorrectIndication];
        [[DataManager sharedManager] updateCorrectAnswer];
        [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:kImageTriviaNextQuestionDelay];
        
    } else {
        [[DataManager sharedManager] updateWrongAnswer];
        [self.topLeftMemberCell showWrongIndication];
    }
}

- (void) topRightViewTapped {
    if ([self checkCorrectnessOfPosition:kCellPositionTopRight]) {
        [self.topRightMemberCell showCorrectIndication];
        [[DataManager sharedManager] updateCorrectAnswer];
        [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:kImageTriviaNextQuestionDelay];
    } else {
        [[DataManager sharedManager] updateWrongAnswer];
        [self.topRightMemberCell showWrongIndication];
    }
}

- (void) bottomLeftViewTapped {
    if ([self checkCorrectnessOfPosition:kCellPositionBottomLeft]) {
        [self.bottomLeftMemberCell showCorrectIndication];
        [[DataManager sharedManager] updateCorrectAnswer];
        [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:kImageTriviaNextQuestionDelay];
    } else {
        [[DataManager sharedManager] updateWrongAnswer];
        [self.bottomLeftMemberCell showWrongIndication];
    }
}

- (void) bottomRightViewTapped {
    if ([self checkCorrectnessOfPosition:kCellPositionBottomRight]) {
        [self.bottomRightMemberCell showCorrectIndication];
        [[DataManager sharedManager] updateCorrectAnswer];
        [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:kImageTriviaNextQuestionDelay];
    } else {
        [[DataManager sharedManager] updateWrongAnswer];
        [self.bottomRightMemberCell showWrongIndication];
    }
}



@end
