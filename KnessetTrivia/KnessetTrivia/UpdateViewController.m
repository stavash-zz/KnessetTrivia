//
//  DataUpdateViewController.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 1/25/13.
//
//

#import "UpdateViewController.h"
#import <QuartzCore/QuartzCore.h>

typedef enum{
    kUpdateDataTypeMember,
    kUpdateDataTypeParty,
    kUpdateDataTypeBills
}UpdateDataType;

typedef void (^UpdateCompletionBlock)(BOOL success);

#define kKnessetTriviaMemberUrl @"http://oknesset.org/api/v2/member/?format=json&extra_fields=current_role_descriptions,gender,is_current,party_name,place_of_residence"
#define kKnessetTriviaPartyUrl @"http://oknesset.org/api/v2/party/?format=json"
#define kKnessetTriviaBillsUrl @"http://oknesset.org/api/v2/bills/?format=json"
#define kDownloadTimeoutInterval 20.0


@interface UpdateViewController ()

@property (retain, nonatomic) NSURLConnection *activeConnection;
@property (retain, nonatomic) NSMutableData *downloadData;
@property (retain, nonatomic) DACircularProgressView *theProgressView;
@property (assign, nonatomic) long long expectedContentLength;
@property (retain, nonatomic) NSData *memberData;
@property (retain, nonatomic) NSData *partyData;
@property (retain, nonatomic) NSData *billsData;

@property (strong, nonatomic) UpdateCompletionBlock updateCompletionBlock;

@end

@implementation UpdateViewController

@synthesize delegate;

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
    [super viewDidLoad];
 
    ivBackground.layer.cornerRadius = 5.0f;
    ivBackground.layer.shadowColor = [UIColor blackColor].CGColor;
    [ivBackground.layer setShadowOffset:CGSizeMake(3.0f, 3.0f)];
    ivBackground.layer.shadowOpacity = 0.6;
    ivBackground.layer.shadowRadius = 20.0;
    ivBackground.clipsToBounds = NO;
    
    DACircularProgressView *circularProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(130.0f, 210.0f, 60.0f, 60.0f)];
    circularProgressView.roundedCorners = NO;
    circularProgressView.trackTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.4f];
    circularProgressView.thicknessRatio = 0.4f;
    circularProgressView.progressTintColor = [UIColor colorWithRed:0.0f green:0.1f blue:1.0f alpha:0.8f];
    [self.view addSubview:circularProgressView];
    self.theProgressView = circularProgressView;
    [circularProgressView release];
    
    [self startUpdateForData:kUpdateDataTypeMember onCompletion:^(BOOL success) {
        if (success) {
            self.memberData = [NSData dataWithData:self.downloadData];
            [self startUpdateForData:kUpdateDataTypeParty onCompletion:^(BOOL success) {
                if (success) {
                    self.partyData = [NSData dataWithData:self.downloadData];
                    [self startUpdateForData:kUpdateDataTypeBills onCompletion:^(BOOL success) {
                        if (success) {
                            self.billsData = [NSData dataWithData:self.downloadData];
                            if ([self.delegate respondsToSelector:@selector(updateDownloadCompleteWithMemberData:andPartyData:andBillsData:)]) {
                                [self.delegate updateDownloadCompleteWithMemberData:self.memberData
                                                                       andPartyData:self.partyData
                                                                       andBillsData:self.billsData];
                            }
                        } else {
                            [self updateFailed];
                        }
                    }];
                } else {
                    [self updateFailed];
                }
            }];
        } else {
            [self updateFailed];
        }
    }];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.downloadData = nil;
    self.delegate = nil;
    self.activeConnection = nil;
    [super dealloc];
}

#pragma mark - Private

- (void)updateFailed {
    if ([self.delegate respondsToSelector:@selector(updateDownloadFailed)]) {
        [self.delegate updateDownloadFailed];
    }
}

- (void)startUpdateForData:(UpdateDataType)dataType onCompletion:(UpdateCompletionBlock)completionHandler{
    NSMutableData *data = [[NSMutableData alloc] init];
    self.downloadData = data;
    [data release];
    
    NSString *urlStr = nil;
    switch (dataType) {
        case kUpdateDataTypeBills:
            lblCurrentDownload.text = @"מעדכן נתוני הצעות חוק";
            urlStr = kKnessetTriviaBillsUrl;
            break;
        case kUpdateDataTypeMember:
            lblCurrentDownload.text = @"מעדכן נתוני חברי כנסת";
            urlStr = kKnessetTriviaMemberUrl;
            break;
        case kUpdateDataTypeParty:
            lblCurrentDownload.text = @"מעדכן נתוני מפלגות";
            urlStr = kKnessetTriviaPartyUrl;
            break;
        default:
            return;
            break;
    }
    
    self.updateCompletionBlock = completionHandler;
    
    NSURLRequest *memberDownloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:kDownloadTimeoutInterval];
    NSURLConnection *newConnection = [[NSURLConnection alloc] initWithRequest:memberDownloadRequest delegate:self];
    self.activeConnection = newConnection;
    [newConnection release];
    
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.updateCompletionBlock) {
        self.updateCompletionBlock(NO);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.expectedContentLength = [response expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadData appendData:data];
    float progress = 0.0f;
    if (self.expectedContentLength > 0) {
        progress = ((float)[self.downloadData length] / (float)self.expectedContentLength);
    }
    [self.theProgressView setProgress:progress];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.updateCompletionBlock) {
        self.updateCompletionBlock(YES);
    }
}


@end
