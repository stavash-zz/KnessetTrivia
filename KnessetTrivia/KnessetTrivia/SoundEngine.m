//
//  SoundEngine.m
//  OpenKnesset
//
//  Created by Stav Ashuri on 4/12/11.
//

#import "SoundEngine.h"
#import "SoundFilenames.h"

#define kSoundEngineSoundOnDefaultsKey @"soundOn"
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
				AudioServicesPlaySystemSound(SoundCodeCorrectAnswer);
				break;
			case kSoundCodeWrongAnswer:
				AudioServicesPlaySystemSound(SoundCodeWrongAnswer);
				break;
            case kSoundCodeTimeIsUp:
                AudioServicesPlaySystemSound(SoundCodeTimeIsUp);
			default:
				break;
		}
	}
}


#pragma mark -
#pragma mark Sound getter/setter

- (void) setSoundON:(BOOL)newValue
{
    NSNumber *numBool = [NSNumber numberWithBool:newValue];
    [[NSUserDefaults standardUserDefaults] setObject:numBool forKey:kSoundEngineSoundOnDefaultsKey];
	soundON = newValue;
}

- (BOOL) getSoundState {
    return soundON;
}


#pragma mark -
#pragma mark default

- (id) init
{
    self = [super init];
	if (self)
	{
        NSNumber *soundBool = [[NSUserDefaults standardUserDefaults] objectForKey:kSoundEngineSoundOnDefaultsKey];
        if (soundBool) {
            soundON = [soundBool boolValue];
        } else {
            soundON = YES;
        }
		
		CFBundleRef mainBundle = CFBundleGetMainBundle ();
		
		CFURLRef soundFileURLRef  = CFBundleCopyResourceURL (mainBundle,	CFSTR (CORRECT_ANSWER), CFSTR (MP3_EXTENSION_), NULL);
		AudioServicesCreateSystemSoundID (soundFileURLRef, &SoundCodeCorrectAnswer);
		
		soundFileURLRef  = CFBundleCopyResourceURL (mainBundle,	CFSTR (WRONG_ANSWER), CFSTR (WAV_EXTENSION_), NULL);
		AudioServicesCreateSystemSoundID (soundFileURLRef, &SoundCodeWrongAnswer);
        
        soundFileURLRef  = CFBundleCopyResourceURL (mainBundle,	CFSTR (TIME_UP), CFSTR (WAV_EXTENSION_), NULL);
		AudioServicesCreateSystemSoundID (soundFileURLRef, &SoundCodeTimeIsUp);
        
		        
		currentMusicCode = -1;
		
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
