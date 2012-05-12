//
//  ImageTriviaViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/28/12.
//   
//

#import "ImageTriviaViewController.h"
#import "DataManager.h"
#import "KTMember.h"
#import "MemberCellViewController.h"
#import "ScoreManager.h"
#import "GoogleAnalyticsLogger.h"

#define kImageTriviaNextQuestionDelay 0.4
#define kImageTriviaFemaleRatioCoeff 10
#define kImageTriviaInstructionFormat @"זהה את %@"

@interface ImageTriviaViewController ()

@end

@implementation ImageTriviaViewController
@synthesize delegate;
@synthesize topLeftMemberCell,topRightMemberCell,bottomLeftMemberCell,bottomRightMemberCell;
@synthesize optionsArr, gameTimer;
@synthesize choicesArr, otherChoicesArr;

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
    //Log to analytics
    int correctId = [self getCorrectMemberWithIndex:correctIndex].memberId;    
    [[GoogleAnalyticsLogger sharedLogger] logImageTriviaChoices:self.choicesArr forMember:correctId otherMembersDisplayed:self.otherChoicesArr andTime:secondsElapsed];

    //Advance
    [self.delegate advanceToNextQuestion];
}

- (KTMember *)getCorrectMemberWithIndex:(int)index {
    return [self.optionsArr objectAtIndex:index];
}

- (void) loadNewQuestion {
        
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
    
    [self.choicesArr removeAllObjects];
    [self.otherChoicesArr removeAllObjects];
    
    //Populate question
    int randGender = arc4random() % kImageTriviaFemaleRatioCoeff;
    if (randGender == 0) {
        self.optionsArr = [[DataManager sharedManager] getFourRandomMembersOfGender:kGenderFemale];
    } else {
        self.optionsArr = [[DataManager sharedManager] getFourRandomMembersOfGender:kGenderMale];
    }
    if (!self.optionsArr) {
        return;
    }
    
    for (KTMember *member in self.optionsArr) {
        [self.otherChoicesArr addObject:[NSNumber numberWithInt:member.memberId]];
    }
    
    correctIndex = arc4random() % 4;
    KTMember *correctMember = [self getCorrectMemberWithIndex:correctIndex];
    questionLabel.text = [NSString stringWithFormat:kImageTriviaInstructionFormat,correctMember.name];
    [self setCell:kCellPositionTopLeft withMember:[self.optionsArr objectAtIndex:0]];
    [self setCell:kCellPositionTopRight withMember:[self.optionsArr objectAtIndex:1]];
    [self setCell:kCellPositionBottomLeft withMember:[self.optionsArr objectAtIndex:2]];
    [self setCell:kCellPositionBottomRight withMember:[self.optionsArr objectAtIndex:3]];
    
    [self hideAllInfoButtons];
    
    //analytics setup
    tries = 0;
    secondsElapsed = 0;
    self.gameTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(incrementSecondsElapsed) userInfo:nil repeats:YES];
    [self.gameTimer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSDefaultRunLoopMode];
    
    [UIView beginAnimations:@"" context:nil];
    helpButton.alpha = 1;
    [UIView commitAnimations];
}

- (void) viewDidAppear:(BOOL)animated {    

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
    
    [self performSelector:@selector(loadNewQuestion) withObject:nil afterDelay:0.1];
    
    NSMutableArray *arrForChoices = [[NSMutableArray alloc] init];
    self.choicesArr = arrForChoices;
    [arrForChoices release];
    
    NSMutableArray *arrForOtherChoices = [[NSMutableArray alloc] init];
    self.otherChoicesArr = arrForOtherChoices;
    [arrForOtherChoices release];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.topLeftMemberCell = nil;
    self.topRightMemberCell = nil;
    self.bottomLeftMemberCell = nil;
    self.bottomRightMemberCell = nil;
    self.optionsArr = nil;
    self.gameTimer = nil;
    self.choicesArr = nil;
    self.otherChoicesArr = nil;
    
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
    
    [[ScoreManager sharedManager] updateHelpRequested];
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

- (void) handleSelectionOfCellPosition:(CellPosition)position {
    MemberCellViewController *selectedMemberCell = nil;
    switch (position) {
        case kCellPositionTopLeft:
            selectedMemberCell = self.topLeftMemberCell;
            break;
        case kCellPositionTopRight:
            selectedMemberCell = self.topRightMemberCell;
            break;
        case kCellPositionBottomLeft:
            selectedMemberCell = self.bottomLeftMemberCell;
            break;
        case kCellPositionBottomRight:
            selectedMemberCell = self.bottomRightMemberCell;
            break;
        default:
            break;
    }
    
    if ([self checkCorrectnessOfPosition:position]) {
        if (selectedMemberCell.myResultState == kResultUnknown) {
            [[ScoreManager sharedManager] updateCorrectAnswer];
        }
        [selectedMemberCell showCorrectIndication];
        [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:kImageTriviaNextQuestionDelay];
        
    } else {
        if (selectedMemberCell.myResultState == kResultUnknown) {
            [[ScoreManager sharedManager] updateWrongAnswer];
            tries++;
        }
        [selectedMemberCell showWrongIndication];
        NSNumber *wrongMemberId = [NSNumber numberWithInt:selectedMemberCell.member.memberId];
        [self.choicesArr addObject:wrongMemberId];
        [self.otherChoicesArr removeObject:wrongMemberId];
    }
}


- (void) topLeftViewTapped {
    [self handleSelectionOfCellPosition:kCellPositionTopLeft];
}

- (void) topRightViewTapped {
    [self handleSelectionOfCellPosition:kCellPositionTopRight];
}

- (void) bottomLeftViewTapped {
    [self handleSelectionOfCellPosition:kCellPositionBottomLeft];
}

- (void) bottomRightViewTapped {
    [self handleSelectionOfCellPosition:kCellPositionBottomRight];
}

#pragma mark - Game Timer
- (void) incrementSecondsElapsed {
    secondsElapsed++;
}

@end
