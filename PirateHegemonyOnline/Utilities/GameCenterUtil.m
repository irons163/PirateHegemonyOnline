//
//  GameCenterUtil.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/6/12.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameCenterUtil.h"

static GameCenterUtil* instance;

@implementation GameCenterUtil{
    BOOL gameCenterAvailable;
}

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

- (BOOL) isGameCenterAvailable
{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (void)authenticateLocalUser:(UIViewController*)m_viewController{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if(error){
            NSLog(@"%@", error.description);
        }
        if (viewController != nil) {
            [m_viewController presentViewController:viewController animated:YES completion:^{
                
            }];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                // Get the default leaderboard identifier.
                
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        NSLog(@"%@", @"authenticated no error");
                    }
                }];
            }
            
            else{
                NSLog(@"%@", @"authenticated not");
                [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
            }
        }
    };
}

- (void)registerFoeAuthenticationNotification{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
}

- (void)authenticationChanged{
    if([GKLocalPlayer localPlayer].isAuthenticated ){
        NSLog(@"Authentication changed: player authenticated.");
//        userAuthenticated = TRUE;
    }else{
        NSLog(@"Authentication changed: player not authenticated");
//        userAuthenticated = FALSE;
    }
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    
    scoreReporter.value = score;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if(error != nil){
            NSData *saveSocreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
            
            [self storeScoreForLater:saveSocreData];
        }else{
            NSLog(@"提交成功");
        }
    }];
}

- (void)storeScoreForLater:(NSData *)scoreData{
    NSMutableArray *savedScoresArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    
    [savedScoresArray addObject:scoreData];
    [[NSUserDefaults standardUserDefaults] setObject:savedScoresArray forKey:@"savedScores"];
}

- (void)submitAllSavedScores{
    NSMutableArray *savedScoreArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedScores"];
    
    for(NSData *scoreData in savedScoreArray){
        GKScore *scoreReporter = [NSKeyedUnarchiver unarchiveObjectWithData:scoreData];
        
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            if(error != nil){
                NSData *saveSocreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
                [self storeScoreForLater:saveSocreData];
            }else{
                NSLog(@"提交成功");
                
                
            }
        }];
    }
}

- (void)showGameCenter:(UIViewController*)viewController{
    GKGameCenterViewController *gameView = [[GKGameCenterViewController alloc] init];
    if(gameView != nil){
        gameView.gameCenterDelegate = self;
        
        [gameView setLeaderboardCategory:@"com.xxxx.test"];
        [gameView setLeaderboardTimeScope:GKLeaderboardTimeScopeAllTime];
        
        [viewController presentViewController:gameView animated:YES completion:^{
            
        }];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
