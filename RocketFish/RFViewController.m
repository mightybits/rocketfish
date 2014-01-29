//
//  RFViewController.m
//  RocketFish
//
//  Created by Tate Jennings on 1/25/14.
//  Copyright (c) 2014 Tate Jennings. All rights reserved.
//

#import "RFViewController.h"
#import "RFGameScene.h"
#import "RFHomeScene.h"

@implementation RFViewController

- (void)viewWillLayoutSubviews
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {
//        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [RFHomeScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
