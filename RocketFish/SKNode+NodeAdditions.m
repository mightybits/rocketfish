//
//  SKNode+NodeAdditions.m
//  RocketFish
//
//  Created by Tate Jennings on 1/26/14.
//  Copyright (c) 2014 Tate Jennings. All rights reserved.
//

#import "SKNode+NodeAdditions.h"

@implementation SKNode (NodeAdditions)

- (void) move:(CGPoint)point
{
    self.position = CGPointMake(self.position.x + point.x, self.position.y + point.y);
}

- (void) moveX:(CGFloat)x
{
    self.position = CGPointMake(self.position.x + x, self.position.y);
}

- (void) moveY:(CGFloat)y
{
    self.position = CGPointMake(self.position.x, self.position.y + y);
}


@end
