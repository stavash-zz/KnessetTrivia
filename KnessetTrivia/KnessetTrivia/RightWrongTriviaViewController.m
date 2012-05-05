//
//  RightWrongTriviaViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 5/1/12.
//   
//

#import "RightWrongTriviaViewController.h"
#import "KTMember.h"
#import "DataManager.h"
#import "MemberCellViewController.h"
#import "ScoreManager.h"
#import "GoogleAnalyticsLogger.h"

#define kRightWrongQuestionAgeOffset 4

@interface RightWrongTriviaViewController ()

@end

@implementation RightWrongTriviaViewController

@synthesize currentMember,currentObject, cellVC, delegate, gameTimer;

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
    [self performSelector:@selector(loadNewQuestion) withObject:nil afterDelay:0.1];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.currentMember = nil;
    self.currentObject = nil;
    self.cellVC = nil;
    self.gameTimer = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Animations

- (void) updateResult:(BOOL)isCorrect {
    //Show result indication
    self.view.userInteractionEnabled = NO;
    if (isCorrect) {
        [self.cellVC showCorrectIndication];
    } else {
        [self.cellVC showWrongIndication];
    }

    //Log answer to analytics
    [[GoogleAnalyticsLogger sharedLogger] logSecondsToAnswerForRightWrongTrivia:secondsElapsed forMemberId:self.currentMember.memberId questionType:currentQuestionType isCorrect:isCorrect];

    //Advance
    [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:0.5];
}


#pragma mark - IBActions

- (IBAction)rightPressed:(id)sender {
    BOOL result = [self validateAnswer:YES];
    if (result) {
        [[ScoreManager sharedManager] updateCorrectAnswer];
        [self updateResult:YES];
    } else {
        [[ScoreManager sharedManager] updateWrongAnswer];
        [self updateResult:NO];
    }
}

- (IBAction)wrongPressed:(id)sender {
    BOOL result = [self validateAnswer:NO];
    if (result) {
        [[ScoreManager sharedManager] updateCorrectAnswer];
        [self updateResult:YES];
    } else {
        [[ScoreManager sharedManager] updateWrongAnswer];
        [self updateResult:NO];
    }
}

- (IBAction)helpPressed:(id)sender {
    [self.cellVC showInfoButton];

    [UIView beginAnimations:@"" context:nil];
    helpButton.alpha = 0;
    [UIView commitAnimations];

    [[ScoreManager sharedManager] updateHelpRequested];
}

#pragma mark - Question generation

- (void) loadNextQuestion {
    [self.delegate advanceToNextQuestion];
}

- (void) loadNewQuestion {
    //reset view
    self.view.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.23];
    if (self.cellVC) {
        [self.cellVC.view removeFromSuperview];
    }
    self.cellVC = nil;
    [UIView beginAnimations:@"" context:nil];
    helpButton.alpha = 1;
    [UIView commitAnimations];

    
    //generate question type and member
    currentQuestionType = arc4random() % questionOptionsCount;
    currentMember = [[DataManager sharedManager] getRandomMember];
    
    //add image cell
    MemberCellViewController *newCellVC = [[MemberCellViewController alloc] initWithNibName:@"MemberCellViewController" bundle:nil];
    newCellVC.member = currentMember;
    newCellVC.view.frame = CGRectMake(112, 140, 95, 140);
    [self.view addSubview:newCellVC.view];
    self.cellVC = newCellVC;
    [newCellVC release];
    
    //display question
    switch (currentQuestionType) {
        case kRightWrongQuestionTypeParty:
        {
            NSArray *parties = [[DataManager sharedManager] getAllParties];
            int randomPartyIndex = arc4random() % [parties count];
            NSString *party = [parties objectAtIndex:randomPartyIndex];
            NSString *questionReference;
            if (currentMember.gender == kGenderMale) {
                questionReference = @"הוא חבר";
            } else {
                questionReference = @"היא חברה";
            }
            NSString *question = [NSString stringWithFormat:@"%@ %@ במפלגת %@",currentMember.name,questionReference,party];
            questionLabel.text = question;
            self.currentObject = party;
        }
            break;
        case kRightWrongQuestionTypeAge:
        {
            BOOL falseAnswer = arc4random() % 2;
            int age = [[DataManager sharedManager] getAgeForMember:currentMember];
            if (falseAnswer) {
                int randomOffset = (arc4random() % kRightWrongQuestionAgeOffset*2)-kRightWrongQuestionAgeOffset;
                age += randomOffset;
            }
            NSString *questionReference;
            if (currentMember.gender == kGenderMale) {
                questionReference = @"הוא בן";
            } else {
                questionReference = @"היא בת";
            }

            NSString *question = [NSString stringWithFormat:@"%@ %@ %d",currentMember.name,questionReference,age];
            questionLabel.text = question;
            self.currentObject = [NSNumber numberWithInt:age];
        }
            break;
            
        default:
            break;
    }
    
    secondsElapsed = 0;
    self.gameTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(incrementSecondsElapsed) userInfo:nil repeats:YES];
    [self.gameTimer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSDefaultRunLoopMode];

}

#pragma mark - Answer validation

- (BOOL) validateAnswer:(BOOL)trueAnswer {
    BOOL correct = NO;
    switch (currentQuestionType) {
        case kRightWrongQuestionTypeAge:
        {
            NSNumber *currentObjectNum = (NSNumber *)self.currentObject;
            int age = [currentObjectNum intValue];
            correct = ([[DataManager sharedManager] getAgeForMember:currentMember] == age);
            return correct == trueAnswer;
        }
        case kRightWrongQuestionTypeParty:
        {
            NSString *currentObjectString = (NSString *)self.currentObject;
            correct = [currentObjectString isEqualToString:currentMember.party];
        }
            break;
        default:
            return NO;
            break;
    }
    return correct == trueAnswer;
}

#pragma mark - Game Timer
- (void) incrementSecondsElapsed {
    secondsElapsed++;
}


@end
