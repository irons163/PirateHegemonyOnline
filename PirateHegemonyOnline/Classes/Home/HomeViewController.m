//
//  HomeViewController.m
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import "HomeViewController.h"
#import "DrawCardViewController.h"
#import "GameCenterUtil.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import <AVKit/AVKit.h>

@interface HomeViewController () {
    AVPlayerLooper *playerLooper;
}

@property AVPlayer *avPlayer;

@property (weak, nonatomic) IBOutlet UIView *videoHolderView;

@property (weak, nonatomic) IBOutlet UIButton *getSClassMusketeerButton;
@property (weak, nonatomic) IBOutlet UIButton *getRandomClassMusketeerButton;

- (IBAction)getSClassMusketeerButtonClick:(id)sender;
- (IBAction)getRandomClassMusketeerClick:(id)sender;
- (IBAction)showGameCenterButtonClick:(id)sender;
- (IBAction)showTaiwantrilogyWebButtonClick:(id)sender;
- (IBAction)showYoutubeVideoButtonClick:(id)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
//    NSString *webStringURL = [@"https://reurl.cc/Oqp46D" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *webStringURL = [@"https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];
    self.avPlayer = [[AVQueuePlayer alloc] init];
    [self.avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoURL];
    playerLooper = [AVPlayerLooper playerLooperWithPlayer:self.avPlayer templateItem:playerItem];

    AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    playerLayer.frame = self.videoHolderView.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.needsDisplayOnBoundsChange = YES;

    [self.videoHolderView.layer addSublayer:playerLayer];
    self.videoHolderView.layer.needsDisplayOnBoundsChange = YES;
    
    NSInteger totalPower = [[DBManager sharedInstance] getTotalPower];
    if (totalPower == 0) {
        self.getSClassMusketeerButton.hidden = NO;
        self.getRandomClassMusketeerButton.hidden = YES;
    } else {
        self.getSClassMusketeerButton.hidden = YES;
        self.getRandomClassMusketeerButton.hidden = NO;
    }
    
//    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
//    [gameCenterUtil isGameCenterAvailable];
//    [gameCenterUtil authenticateLocalUser:self];
//    [gameCenterUtil submitAllSavedScores];
}

- (void)showRankViewController {
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil isGameCenterAvailable];
//    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil showGameCenter:self];
    [gameCenterUtil submitAllSavedScores];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == self.avPlayer && [keyPath isEqualToString:@"status"]) {
        if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {
//            playButton.enabled = YES;
            [self.avPlayer play];
        } else if (self.avPlayer.status == AVPlayerStatusFailed) {
            // something went wrong. player.error should contain some information
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getSClassMusketeerButtonClick:(id)sender {
    DrawCardViewController *drawCardViewController = [[DrawCardViewController alloc] init];
    drawCardViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    drawCardViewController.drawSClassCard = YES;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController presentViewController:drawCardViewController animated:YES completion:nil];
}

- (IBAction)getRandomClassMusketeerClick:(id)sender {
    DrawCardViewController *drawCardViewController = [[DrawCardViewController alloc] init];
    drawCardViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController presentViewController:drawCardViewController animated:YES completion:nil];
}

- (IBAction)showYoutubeVideoButtonClick:(id)sender {
    
}

- (IBAction)showTaiwantrilogyWebButtonClick:(id)sender {
    
}

- (IBAction)showGameCenterButtonClick:(id)sender {
    
}

@end


