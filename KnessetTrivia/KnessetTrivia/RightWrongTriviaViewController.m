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

#define kRightWrongQuestionPlaceOfBirthMaleReference @"נולד ב"
#define kRightWrongQuestionPlaceOfBirthFemaleReference @"נולדה ב"
#define kRightWrongQuestionPlaceOfBirthQuestionFormat @"%@ %@%@"

#define kRightWrongQuestionAgeMaleReference @"הוא בן"
#define kRightWrongQuestionAgeFemaleReference @"היא בת"
#define kRightWrongQuestionAgeQuestionFormat @"%@ %@ %d"

#define kRightWrongQuestionPartyMaleReference @"הוא חבר"
#define kRightWrongQuestionPartyFemaleReference @"היא חברה"
#define kRightWrongQuestionPartyQuestionFormat @"%@ %@ במפלגת %@"

#define kRightWrongQuestionRoleMaleReference @"הוא"
#define kRightWrongQuestionRoleFemaleReference @"היא"
#define kRightWrongQuestionRoleQuestionFormat @"%@ %@ %@"

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

#pragma mark - Randomization
+ (BOOL) generateRandomBoolean {
    int randInt = arc4random() % 2;
    if (randInt == 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Animations

- (void) updateResult:(BOOL)isCorrect withGuess:(BOOL)guess{
    //Show result indication
    self.view.userInteractionEnabled = NO;
    if (isCorrect) {
        [self.cellVC showCorrectIndication];
    } else {
        [self.cellVC showWrongIndication];
    }

    //Log answer to analytics
    [[GoogleAnalyticsLogger sharedLogger] logRightWrongAnswerForMember:currentMember.memberId ofQuestionType:currentQuestionType userGuess:guess isCorrect:isCorrect answerDisplayed:currentObject timeToAnswer:secondsElapsed];

    //Advance
    [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:0.5];
}


#pragma mark - IBActions

- (IBAction)rightPressed:(id)sender {
    if (!self.currentMember) {
        return;
    }
    BOOL result = [self validateAnswer:YES];
    if (result) {
        [[ScoreManager sharedManager] updateCorrectAnswer];
        [self updateResult:YES withGuess:YES];
    } else {
        [[ScoreManager sharedManager] updateWrongAnswer];
        [self updateResult:NO withGuess:YES];
    }
}

- (IBAction)wrongPressed:(id)sender {
    if (!self.currentMember) {
        return;
    }
    BOOL result = [self validateAnswer:NO];
    if (result) {
        [[ScoreManager sharedManager] updateCorrectAnswer];
        [self updateResult:YES withGuess:NO];
    } else {
        [[ScoreManager sharedManager] updateWrongAnswer];
        [self updateResult:NO withGuess:NO];
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
                return kRightWrongQuestionPlaceOfBirthMaleReference;
            } else if (gender == kGenderFemale) {
                return kRightWrongQuestionPlaceOfBirthFemaleReference;
            }
        }
            break;
        case kRightWrongQuestionTypeAge:
        {
            if (gender == kGenderMale) {
                return kRightWrongQuestionAgeMaleReference;
            } else if (gender == kGenderFemale) {
                return kRightWrongQuestionAgeFemaleReference;
            }
            
        }
            break;
        case kRightWrongQuestionTypeParty:
        {
            if (gender == kGenderMale) {
                return kRightWrongQuestionPartyMaleReference;
            } else if (gender == kGenderFemale) {
                return kRightWrongQuestionPartyFemaleReference;
            }
            
        }
            break;
        case kRightWrongQuestionTypeRole:
        {
            if (gender == kGenderMale) {
                return kRightWrongQuestionRoleMaleReference;
            } else if (gender == kGenderFemale) {
                return kRightWrongQuestionRoleFemaleReference;
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
    if (DEBUG_ALWAYS_AGE) {
        currentQuestionType = kRightWrongQuestionTypeAge;
    } else if (DEBUG_ALWAYS_PARTY) {
        currentQuestionType = kRightWrongQuestionTypeParty;
    } else if (DEBUG_ALWAYS_POB) {
        currentQuestionType = kRightWrongQuestionTypePlaceOfBirth;
    } else if (DEBUG_ALWAYS_ROLE) {
        currentQuestionType = kRightWrongQuestionTypeRole;
    }
    
    if (currentQuestionType != kRightWrongQuestionTypeRole) {
        currentMember = [[DataManager sharedManager] getRandomMember];
    } else {
        currentMember = [[DataManager sharedManager] getRandomMemberWithRole];
    }
    
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
            BOOL falseAnswer = [RightWrongTriviaViewController generateRandomBoolean];
            NSString *party = nil;
            if (falseAnswer) {
                NSArray *parties = [[DataManager sharedManager] getAllParties];
                int randomPartyIndex = arc4random() % [parties count];
                party = [parties objectAtIndex:randomPartyIndex];
            } else {
                party = currentMember.party;
            }

            question = [NSString stringWithFormat:kRightWrongQuestionPartyQuestionFormat,currentMember.name,questionReference,party];
            self.currentObject = party;
        }
            break;
        case kRightWrongQuestionTypeAge:
        {
            BOOL falseAnswer = [RightWrongTriviaViewController generateRandomBoolean];
            int age = [[DataManager sharedManager] getAgeForMember:currentMember];
            if (falseAnswer) {
                int randomOffset = (arc4random() % kRightWrongQuestionAgeOffset*2)-kRightWrongQuestionAgeOffset;
                age += randomOffset;
            }

            question = [NSString stringWithFormat:kRightWrongQuestionAgeQuestionFormat,currentMember.name,questionReference,age];
            self.currentObject = [NSNumber numberWithInt:age];
        }
            break;
        case kRightWrongQuestionTypePlaceOfBirth:
        {
            BOOL falseAnswer = [RightWrongTriviaViewController generateRandomBoolean];
            NSString *questionPob = nil;
            if (falseAnswer) {
                NSArray *places = [[DataManager sharedManager] getAllPlacesOfBirth];
                int randomIndex = arc4random() % [places count];
                questionPob = [places objectAtIndex:randomIndex];
            } else {
                questionPob = currentMember.placeOfBirth;
            }
                        
            question = [NSString stringWithFormat:kRightWrongQuestionPlaceOfBirthQuestionFormat,currentMember.name,questionReference,questionPob];
            self.currentObject = questionPob;
        }
            break;
        case kRightWrongQuestionTypeRole:
        {
            BOOL falseAnswer = [RightWrongTriviaViewController generateRandomBoolean];
            NSString *questionRole = nil;
            if (falseAnswer) {
                NSArray *roles = [[DataManager sharedManager] getAllRolesForGender:currentMember.gender];
                int randomIndex = arc4random() % [roles count];
                questionRole = [roles objectAtIndex:randomIndex];
            } else {
                questionRole = currentMember.currentRoleDescriptions;
            }
            
            question = [NSString stringWithFormat:kRightWrongQuestionRoleQuestionFormat,currentMember.name,questionReference,questionRole];
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
            break;
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
