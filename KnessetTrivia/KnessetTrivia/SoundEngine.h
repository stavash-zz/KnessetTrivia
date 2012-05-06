//
//  SoundEngine.h
//  OpenKnesset
//
//  Created by Stav Ashuri on 4/12/11.
//

#import <Foundation/Foundation.h>
#import <AudioToolBox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>

enum SoundCodes
{
    kSoundCodeCorrectAnswer,
    kSoundCodeWrongAnswer,
    kSoundCodeTimeIsUp
};

@interface SoundEngine : NSObject <AVAudioPlayerDelegate>
{
	BOOL soundON;
	int currentMusicCode;
    
    SystemSoundID SoundCodeCorrectAnswer;
    SystemSoundID SoundCodeWrongAnswer;
    SystemSoundID SoundCodeTimeIsUp;
}

+ (SoundEngine *)sharedSoundEngine;

- (void) play:(int)soundCode;
- (void) setSoundON:(BOOL)newValue;
- (BOOL) getSoundState;

@end
