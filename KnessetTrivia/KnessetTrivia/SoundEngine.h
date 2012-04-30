//
//  SoundEngine.h
//  Spitch
//
//  Created by Amir on 4/12/11.
//  Copyright 2011 Zemingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolBox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>

enum SoundCodes
{
    kSoundCodeCorrectAnswer,
    kSoundCodeWrongAnswer
};

@interface SoundEngine : NSObject <AVAudioPlayerDelegate>
{
	BOOL soundON;
	int currentMusicCode;
    
    SystemSoundID SoundCodeCorrectAnswer;
    SystemSoundID SoundCodeWrongAnswer;
}

+ (SoundEngine *)sharedSoundEngine;

- (void) play:(int)soundCode;

@end
