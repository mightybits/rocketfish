//
//  RFHomeScene.m
//  RocketFish
//
//  Created by Tate Jennings on 1/26/14.
//  Copyright (c) 2014 Tate Jennings. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "RFHomeScene.h"
#import "RFGameScene.h"

@interface RFHomeScene ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation RFHomeScene

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"home"];
        bg.position = CGPointMake(0, 0);
        bg.anchorPoint = CGPointZero;
        
        [self addChild:bg];
        
        [self playMusic];
        
        [self runAction:[SKAction playSoundFileNamed:@"rocketfish.mp3" waitForCompletion:NO]];
        
        // Create rocket emitter
        SKEmitterNode* fire  = [self newEmmiterByName:@"RocketFire"];
        fire.position = CGPointMake(288, 146);
        [self addChild:fire];
    
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.audioPlayer stop];
    
    
    // Create and configure the scene.
    SKScene * scene = [RFGameScene sceneWithSize:self.size];
        
    [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:0.4]];

}



-(void)playMusic
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"RocketFishIntro" withExtension:@"mp3"];
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
     
    if (!self.audioPlayer) {
        NSLog(@"Error creating player: %@", error);
    }
    
     self.audioPlayer.volume = 0.6;
    [self.audioPlayer play];
}

- (SKEmitterNode *) newEmmiterByName:(NSString*)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    node.targetNode = self;
    
    return node;
}

@end
