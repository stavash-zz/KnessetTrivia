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
    [[GoogleAnalyticsLogger sharedLogger] logRightWrongAnswerForMember:currentMember.memberId ofQuestionType:currentQuestionType isCorrect:isCorrect answerDisplayed:currentObject timeToAnswer:secondsElapsed];

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

+ (NSString *)getQuestionReferenceForQuestionType:(RightWrongQuestionType)qType andGender:(MemberGender)gender {
    switch (qType) {
        case kRightWrongQuestionTypePlaceOfBirth:
        {
            if (gender == kGenderMale) {
                return @"נולד ב";
            } else if (gender == kGenderFemale) {
                return @"נולדה ב";
            }
        }
            break;
        case kRightWrongQuestionTypeAge:
        {
            if (gender == kGenderMale) {
                return @"הוא בן";
            } else if (gender == kGenderFemale) {
                return @"היא בת";
            }
            
        }
            break;
        case kRightWrongQuestionTypeParty:
        {
            if (gender == kGenderMale) {
                return @"הוא חבר";
            } else if (gender == kGenderFemale) {
                return @"היא חברה";
            }
            
        }
            break;
        case kRightWrongQuestionTypeRole:
        {
            if (gender == kGenderMale) {
                return @"הוא";
            } else if (gender == kGenderFemale) {
                return @"היא";
            }
        }
            break;
        default:
            break;
    }
    return nil;
}

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
    newCellVC.view.frame = CGRectMake(112, 170, 95, 140);
    [self.view addSubview:newCellVC.view];
    self.cellVC = newCellVC;
    [newCellVC release];
    
    //display question
    NSString *question = nil;
    NSString *questionReference = [RightWrongTriviaViewController getQuestionReferenceForQuestionType:currentQuestionType andGender:currentMember.gender];
    switch (currentQuestionType) {
        case kRightWrongQuestionTypeParty:
        {
            NSArray *parties = [[DataManager sharedManager] getAllParties];
            int randomPartyIndex = arc4random() % [parties count];
            NSString *party = [parties objectAtIndex:randomPartyIndex];

            question = [NSString stringWithFormat:@"%@ %@ במפלגת %@",currentMember.name,questionReference,party];
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

            question = [NSString stringWithFormat:@"%@ %@ %d",currentMember.name,questionReference,age];
            self.currentObject = [NSNumber numberWithInt:age];
        }
            break;
        case kRightWrongQuestionTypePlaceOfBirth:
        {
            BOOL falseAnswer = arc4random() % 2;
            NSString *questionPob = nil;
            if (falseAnswer) {
                NSArray *places = [[DataManager sharedManager] getAllPlacesOfBirth];
                int randomIndex = arc4random() % [places count];
                questionPob = [places objectAtIndex:randomIndex];
            } else {
                questionPob = currentMember.placeOfBirth;
            }
                        
            question = [NSString stringWithFormat:@"%@ %@%@",currentMember.name,questionReference,questionPob];
            self.currentObject = questionPob;
        }
            break;
        case kRightWrongQuestionTypeRole:
        {
            BOOL falseAnswer = arc4random() % 2;
            if (!currentMember.currentRoleDescriptions) {
                falseAnswer = YES;
            }
            NSString *questionRole = nil;
            if (falseAnswer) {
                NSArray *roles = [[DataManager sharedManager] getAllRoles];
                int randomIndex = arc4random() % [roles count];
                questionRole = [roles objectAtIndex:randomIndex];
            } else {
                questionRole = currentMember.currentRoleDescriptions;
            }
            
            question = [NSString stringWithFormat:@"%@ %@ %@",currentMember.name,questionReference,questionRole];
            self.currentObject = questionRole;
        }
            break;
        default:
            break;
    }
    questionLabel.text = question;

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
        }
            break;
        case kRightWrongQuestionTypeParty:
        {
            NSString *currentObjectString = (NSString *)self.currentObject;
            correct = [currentObjectString isEqualToString:currentMember.party];
        }
            break;
        case kRightWrongQuestionTypePlaceOfBirth:
        {
            NSString *currentObjectString = (NSString *)self.currentObject;
            correct = [currentObjectString isEqualToString:currentMember.placeOfBirth];
        }
        case kRightWrongQuestionTypeRole:
        {
            NSString *currentObjectString = (NSString *)self.currentObject;
            correct = [currentObjectString isEqualToString:currentMember.currentRoleDescriptions];
            
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
