//
//  SKNode+NodeAdditions.h
//  RocketFish
//
//  Created by Tate Jennings on 1/26/14.
//  Copyright (c) 2014 Tate Jennings. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

// Vector Math Helpers
static inline CGVector CGVectorAdd(const CGVector a, const CGVector b)
{
    return CGVectorMake(a.dx + b.dx, a.dy + b.dy);
}

static inline CGVector CGVectorSubtract(const CGVector a, const CGVector b)
{
    return CGVectorMake(a.dx - b.dx, a.dy - b.dy);
}

static inline CGVector CGVectorMultiplyScalar(const CGVector a, const CGFloat b)
{
    return CGVectorMake(a.dx * b, a.dy * b);
}

static inline float CGVectorLength(const CGVector a)
{
    return sqrtf(a.dx * a.dx + a.dy * a.dy);
}

static inline CGPoint CGVectorUnit(CGVector a)
{
    float length = CGVectorLength(a);
    return CGPointMake(a.dx / length, a.dy / length);
}

@interface SKNode (NodeAdditions)

- (void) move:(CGPoint)point;
- (void) moveX:(CGFloat)x;
- (void) moveY:(CGFloat)y;

@end
