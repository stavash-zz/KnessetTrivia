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
#import "MemberCell.h"

#define kImageTriviaNextQuestionDelay 0.4

@interface ImageTriviaViewController ()

@end

@implementation ImageTriviaViewController
@synthesize topLeftMemberCell,topRightMemberCell,bottomLeftMemberCell,bottomRightMemberCell;
@synthesize optionsArr;

#pragma mark - Cell setters

- (void) setCell:(CellPosition)pos withMember:(KTMember *)member {
    switch (pos) {
        case kCellPositionTopLeft:
        {
            MemberCell *topLeftCell = [[MemberCell alloc] initWithNibName:@"MemberCell" bundle:nil];
            topLeftCell.member = member;
            [topLeftView addSubview:topLeftCell.view];
            self.topLeftMemberCell = topLeftCell;
            [topLeftCell release];
            
        }
            break;
        case kCellPositionTopRight:
        {
            MemberCell *topRightCell = [[MemberCell alloc] initWithNibName:@"MemberCell" bundle:nil];
            topRightCell.member = member;
            [topRightView addSubview:topRightCell.view];
            self.topRightMemberCell = topRightCell;
            [topRightCell release];
        }
            break;
        case kCellPositionBottomLeft:
        {
            MemberCell *bottomLeftCell = [[MemberCell alloc] initWithNibName:@"MemberCell" bundle:nil];
            bottomLeftCell.member = member;
            [bottomLeftView addSubview:bottomLeftCell.view];
            self.bottomLeftMemberCell = bottomLeftCell;
            [bottomLeftCell release];
        }
            break;
        case kCellPositionBottomRight:
        {
            MemberCell *bottomRightCell = [[MemberCell alloc] initWithNibName:@"MemberCell" bundle:nil];
            bottomRightCell.member = member;
            [bottomRightView addSubview:bottomRightCell.view];
            self.bottomRightMemberCell = bottomRightCell;
            [bottomRightCell release];
        }
            break;
        default:
            break;
    }
}

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"טריוויה";
        self.tabBarItem.image = [UIImage imageNamed:@"TriviaTab"];
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
    self.optionsArr = [self getFourRandomMembers];
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

}

- (void) viewDidAppear:(BOOL)animated {    
    [self loadNextQuestion];
}

- (void) viewDidDisappear:(BOOL)animated {

}

- (void)viewDidLoad
{
    UITapGestureRecognizer *tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topLeftViewTapped)];
    [topLeftView addGestureRecognizer:tapGR1];
    [tapGR1 release];

    UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topRightViewTapped)];
    [topRightView addGestureRecognizer:tapGR2];
    [tapGR2 release];
    
    UITapGestureRecognizer *tapGR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomLeftViewTapped)];
    [bottomLeftView addGestureRecognizer:tapGR3];
    [tapGR3 release];
    
    UITapGestureRecognizer *tapGR4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomRightViewTapped)];
    [bottomRightView addGestureRecognizer:tapGR4];
    [tapGR4 release];
    
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

- (void) updateScoreLabel {
    scoreLabel.text = [NSString stringWithFormat:@"ניקוד: %d",[[DataManager sharedManager] getCurrentScore]];
}

- (KTMember *)getCorrectMember {
    if (self.optionsArr) {
        return [self.optionsArr objectAtIndex:correctIndex];
    }
    return nil;
}

- (NSArray *)getFourRandomMembers {
    
    if ([DataManager sharedManager].members) {
        int memberCount = [[DataManager sharedManager].members count];
        if (memberCount > 3) {
            int index1,index2,index3,index4,randIndex;
            NSMutableArray *randomArr = [[[NSMutableArray alloc] init] autorelease];            
            
            NSMutableArray *remainingOptionsArr = [[NSMutableArray alloc] init];
            for (int i = 0; i < memberCount; i++) {
                NSNumber *num = [NSNumber numberWithInt:i];
                [remainingOptionsArr addObject:num];
            }
            
            //Get random indexes
            randIndex = arc4random() % [remainingOptionsArr count];
            index1 = [[remainingOptionsArr objectAtIndex:randIndex] intValue];
            [remainingOptionsArr removeObjectAtIndex:randIndex];
            randIndex = arc4random() % [remainingOptionsArr count];
            index2 = [[remainingOptionsArr objectAtIndex:randIndex] intValue];
            [remainingOptionsArr removeObjectAtIndex:randIndex];
            randIndex = arc4random() % [remainingOptionsArr count];
            index3 = [[remainingOptionsArr objectAtIndex:randIndex] intValue];
            [remainingOptionsArr removeObjectAtIndex:randIndex];
            randIndex = arc4random() % [remainingOptionsArr count];
            index4 = [[remainingOptionsArr objectAtIndex:randIndex] intValue];
            [remainingOptionsArr removeObjectAtIndex:randIndex];
            
            //Add members from indexes
            [randomArr addObject:[[DataManager sharedManager].members objectAtIndex:index1]];
            [randomArr addObject:[[DataManager sharedManager].members objectAtIndex:index2]];
            [randomArr addObject:[[DataManager sharedManager].members objectAtIndex:index3]];
            [randomArr addObject:[[DataManager sharedManager].members objectAtIndex:index4]];
            
            return randomArr;
        } else {
            NSLog(@"Error - Not enough members!");
        }
    }
    return nil;
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
        [[DataManager sharedManager] updateCorrectImageAnswer];
        [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:kImageTriviaNextQuestionDelay];
        
    } else {
        [[DataManager sharedManager] updateWrongImageAnswer];
        [self.topLeftMemberCell showWrongIndication];
    }
    [self updateScoreLabel];
}

- (void) topRightViewTapped {
    if ([self checkCorrectnessOfPosition:kCellPositionTopRight]) {
        [self.topRightMemberCell showCorrectIndication];
        [[DataManager sharedManager] updateCorrectImageAnswer];
        [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:kImageTriviaNextQuestionDelay];
    } else {
        [[DataManager sharedManager] updateWrongImageAnswer];
        [self.topRightMemberCell showWrongIndication];
    }
    [self updateScoreLabel];
}

- (void) bottomLeftViewTapped {
    if ([self checkCorrectnessOfPosition:kCellPositionBottomLeft]) {
        [self.bottomLeftMemberCell showCorrectIndication];
        [[DataManager sharedManager] updateCorrectImageAnswer];
        [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:kImageTriviaNextQuestionDelay];
    } else {
        [[DataManager sharedManager] updateWrongImageAnswer];
        [self.bottomLeftMemberCell showWrongIndication];
    }
    [self updateScoreLabel];
}

- (void) bottomRightViewTapped {
    if ([self checkCorrectnessOfPosition:kCellPositionBottomRight]) {
        [self.bottomRightMemberCell showCorrectIndication];
        [[DataManager sharedManager] updateCorrectImageAnswer];
        [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:kImageTriviaNextQuestionDelay];
    } else {
        [[DataManager sharedManager] updateWrongImageAnswer];
        [self.bottomRightMemberCell showWrongIndication];
    }
    [self updateScoreLabel];
}



@end
