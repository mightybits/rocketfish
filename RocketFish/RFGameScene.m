//
//  RFGameScene.m
//  RocketFish
//
//  Created by Tate Jennings on 1/25/14.
//  Copyright (c) 2014 Tate Jennings. All rights reserved.
//

#import "RFGameScene.h"
#import "SKNode+NodeAdditions.h"
#import "RFHomeScene.h"


static const uint32_t CollisionFish =  0x1 << 0;
static const uint32_t CollisionBird =  0x1 << 1;
static const uint32_t CollisionBounds =  0x1 << 2;
static const uint32_t CollisionNone  =  0x1 << 3;

@interface RFGameScene () <SKPhysicsContactDelegate>

@end

@implementation RFGameScene
{
    SKTextureAtlas *_characterAtlas;
    SKSpriteNode* _fish;
    SKLabelNode* _score;
    
    BOOL _isTouching;
    BOOL _isAlive;
    int _distance;
    
}

-(id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {
        
        _isAlive = YES;
        _isTouching = NO;
        _characterAtlas = [SKTextureAtlas atlasNamed:@"characters"];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        // Physics World
        self.physicsWorld.gravity = CGVectorMake(0.0, -1);
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        // Scene Collisions
        self.physicsWorld.contactDelegate = self;
        self.physicsBody.categoryBitMask = CollisionBounds;
    
        // Init background
        [self initalizingScrollingBackground];

        
        // Create score label
        _score = [SKLabelNode labelNodeWithFontNamed:@"Verdana-Bold"];
        _score.name = @"score";
        _score.text = @"score label";
        _score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _score.fontSize = 18;
        _score.position = CGPointMake(self.frame.size.width/2 - _score.frame.size.width/2, self.frame.size.height - 24);
        _score.fontColor = [SKColor whiteColor];
        [self addChild:_score];
        
        // Create Fish Sprite
        SKTexture *texture1 = [_characterAtlas textureNamed:@"goldfish-swim-01"];
        SKTexture *texture2 = [_characterAtlas textureNamed:@"goldfish-swim-02"];

        _fish = [SKSpriteNode spriteNodeWithTexture:texture1];
        _fish.position = CGPointMake(140, 200);
        _fish.name = @"fish";
        _fish.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_fish.size.width/4];
        _fish.physicsBody.allowsRotation = NO;
        _fish.physicsBody.mass = 0.2;
        _fish.physicsBody.categoryBitMask = CollisionFish;
        _fish.physicsBody.collisionBitMask = CollisionBounds;
        _fish.physicsBody.contactTestBitMask = CollisionBird;
        
        SKAction *fishFly = [SKAction animateWithTextures:@[texture1,texture2] timePerFrame:.1];
        [_fish runAction:[SKAction repeatActionForever:fishFly]];
        
        [self addChild:_fish];
        
        // Create rocket emitter
        SKEmitterNode* fire  = [self newEmmiterByName:@"RocketFire"];
        fire.position = CGPointMake(-16, -20);
        fire.name = @"fire";
        fire.particleBirthRate = 0;
        [_fish addChild:fire];
        
 
        // Create bird spawning action
        SKAction* spawningSequence = [SKAction sequence:@[  [SKAction performSelector:@selector(spawnBird) onTarget:self],
                                                            [SKAction waitForDuration:2 withRange:1.5]]];
        
        [self runAction:[SKAction sequence:@[   [SKAction waitForDuration:3],
                                                [SKAction repeatActionForever:spawningSequence]]]];
    }
    return self;
}

- (void) spawnBird
{

    SKSpriteNode* bird = [SKSpriteNode spriteNodeWithTexture:[_characterAtlas textureNamed:@"bluejay-sprite-01"]];
    
    // Define spawn range
    int minY = bird.size.height / 2;
    int maxY = self.frame.size.height - bird.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = arc4random_uniform(rangeY) + minY;
    
    bird.position = CGPointMake(self.frame.size.width + bird.size.width/2, actualY);
    bird.name = @"bird";
    bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bird.size.width/4];
    bird.physicsBody.allowsRotation = NO;
    bird.physicsBody.dynamic = NO;
    bird.physicsBody.categoryBitMask = CollisionBird;
    
    bird.userData = [@{@"speed" : @(arc4random_uniform(10) + 3)} mutableCopy];
    
    SKAction *birdFly = [SKAction animateWithTextures:@[[_characterAtlas textureNamed:@"bluejay-sprite-01"],
                                                        [_characterAtlas textureNamed:@"bluejay-sprite-02"],
                                                        [_characterAtlas textureNamed:@"bluejay-sprite-03"]] timePerFrame:.1];
    
    [bird runAction:[SKAction repeatActionForever:birdFly]];
    
    [self runAction:[SKAction playSoundFileNamed:@"cawcaw.mp3" waitForCompletion:NO]];
    
    [self addChild:bird];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isTouching = YES;
    
    SKEmitterNode* fire = (SKEmitterNode*)[self childNodeWithName:@"//fire"];
    fire.particleBirthRate = 100;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isTouching = NO;
    
    SKEmitterNode* fire = (SKEmitterNode*)[self childNodeWithName:@"//fire"];
    fire.particleBirthRate = 0;
}

-(void)update:(NSTimeInterval)currentTime
{
    if(_isAlive)
    {
        _distance ++;
    }
    
    _score.text = [NSString stringWithFormat:@"Distance: %d", _distance];
    
    [self enumerateChildNodesWithName:@"background" usingBlock: ^(SKNode *node, BOOL *stop)
     {
        SKSpriteNode *bg = (SKSpriteNode*)node;
        bg.position = CGPointMake(bg.position.x - 5, bg.position.y);

    
        if (bg.position.x <= -bg.size.width)
        {
            bg.position = CGPointMake(bg.position.x + bg.size.width*2, bg.position.y);
        }
     }];
    
     [self enumerateChildNodesWithName:@"bird" usingBlock: ^(SKNode *node, BOOL *stop)
     {
        SKSpriteNode *bird = (SKSpriteNode*)node;
        CGFloat speed = [[bird.userData objectForKey:@"speed"] floatValue];
        
        bird.position = CGPointMake(bird.position.x - speed, bird.position.y);
         
         
        if(bird.position.x < -bird.size.width)
        {
            [bird removeFromParent];
        }
     }];

    
    
    if(_isTouching && _isAlive)
    {
        // player rocket sound
        if(![_fish actionForKey:@"thusters"])
        {
            SKAction *thrustSound = [SKAction playSoundFileNamed:@"thrust.mp3" waitForCompletion:YES];
            SKAction *playThrustSound = [SKAction repeatActionForever:thrustSound];
            [_fish runAction:playThrustSound withKey:@"thusters"];
        }
        
        
        [_fish.physicsBody applyForce: CGVectorMake(0, 100)];
        
    }else{
    
        [_fish removeActionForKey:@"thusters"];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [self hitBird];
}

-(void)hitBird
{
    _isAlive = NO;
    _fish.physicsBody.collisionBitMask = CollisionNone;
    _fish.physicsBody.contactTestBitMask = CollisionNone;
    
    SKAction *colorAction = [SKAction sequence:@[
                                                [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:.5],
                                                [SKAction colorizeWithColorBlendFactor:0.0 duration:0.5]
                                                ]];
    
    SKAction *hitSound = [SKAction playSoundFileNamed:@"die1.mp3" waitForCompletion:NO];
    SKAction *rollAction = [SKAction repeatActionForever:[SKAction rotateByAngle:-M_PI duration:1]];
    SKAction *hitAction = [SKAction group:@[colorAction, rollAction, hitSound]];
    
    [_fish runAction:hitAction];


    SKAction* gameOverSequence = [SKAction sequence:@[  [SKAction waitForDuration:3],
                                                        [SKAction performSelector:@selector(gameOver) onTarget:self]]];
    
    [self runAction:gameOverSequence];
}

-(void)gameOver
{
    // Create and configure the scene.
    SKScene * scene = [RFHomeScene sceneWithSize:self.size];

    [self.view presentScene:scene transition:[SKTransition doorsCloseHorizontalWithDuration:0.4]];
}

-(void)initalizingScrollingBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"goldfish-background-02"];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"background";
        [self addChild:bg];
    }
}

- (SKEmitterNode *) newEmmiterByName:(NSString*)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    node.targetNode = self;
    
    return node;
}

@end
