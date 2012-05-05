//
//  SoundEngine.m
//  OpenKnesset
//
//  Created by Stav Ashuri on 4/12/11.
//

#import "SoundEngine.h"
#import "SoundFilenames.h"


@implementation SoundEngine

static SoundEngine *sharedSoundEngine = nil;


+ (SoundEngine *)sharedSoundEngine
{
	@synchronized(self) 
	{
		if (sharedSoundEngine == nil) 
		{
			sharedSoundEngine = [[self alloc] init];
		}
	}
	return sharedSoundEngine;
}

#pragma mark - Public

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{	
	[player release];
}

- (void) play:(int)soundCode
{
	if (soundON)
	{
		switch (soundCode)
		{
			case kSoundCodeCorrectAnswer:
				AudioServicesPlaySystemSound (SoundCodeCorrectAnswer);
				break;
			case kSoundCodeWrongAnswer:
				AudioServicesPlaySystemSound (SoundCodeWrongAnswer);
				break;
			default:
				break;
		}
	}
}


#pragma mark -
#pragma mark setter SoundON

- (void) setSoundON:(BOOL)newValue
{
	if (newValue) 
	{
//		[self playBackgroundMusic:currentMusicCode];
	} 
	else
	{
//		[self pauseBackgroundMusic];
	}
	soundON = newValue;
}


#pragma mark -
#pragma mark default

- (id) init
{
    self = [super init];
	if (self)
	{
		soundON = YES;
		
		CFBundleRef mainBundle = CFBundleGetMainBundle ();
		
		CFURLRef soundFileURLRef  = CFBundleCopyResourceURL (mainBundle,	CFSTR (CORRECT_ANSWER), CFSTR (MP3_EXTENSION_), NULL);
		AudioServicesCreateSystemSoundID (soundFileURLRef, &SoundCodeCorrectAnswer);
		
		 soundFileURLRef  = CFBundleCopyResourceURL (mainBundle,	CFSTR (WRONG_ANSWER), CFSTR (MP3_EXTENSION_), NULL);
		AudioServicesCreateSystemSoundID (soundFileURLRef, &SoundCodeWrongAnswer);
		        
		currentMusicCode = -1;
		
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
