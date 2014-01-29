//
//  RFBaseScene.m
//  RocketFish
//
//  Created by Tate Jennings on 1/25/14.
//  Copyright (c) 2014 Tate Jennings. All rights reserved.
//

#import "RFBaseScene.h"

@interface RFBaseScene ()

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@end


@implementation RFBaseScene

- (void)update:(NSTimeInterval)currentTime {
 
    // Handle delta time
    NSTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self update:currentTime deltaTime:timeSinceLast];
}

- (void)update:(NSTimeInterval)currentTime deltaTime:(NSTimeInterval)deltaTime
{
    // override
}


@end
