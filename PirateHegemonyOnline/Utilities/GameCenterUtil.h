//
//  GameCenterUtil.h
//  Try_Cat_Shoot
//
//  Created by irons on 2015/6/12.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "ViewController.h"

@interface GameCenterUtil : NSObject<GKGameCenterControllerDelegate>

+ (id)sharedInstance;
- (BOOL) isGameCenterAvailable;
- (void)authenticateLocalUser:(UIViewController*)viewController;
- (void)showGameCenter:(UIViewController*)viewController;
- (void) reportScore: (int64_t) score forCategory: (NSString*) category;
- (void)submitAllSavedScores;
@end
