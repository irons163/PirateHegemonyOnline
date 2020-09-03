//
//  DrawCardViewController.m
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import "DrawCardViewController.h"
#import "GameCenterUtil.h"
#import "DBManager.h"
#import "ArmFactory.h"

@interface DrawCardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *atkLabel;

- (IBAction)dimissButtonClick:(id)sender;

@end

@implementation DrawCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    Arm *arm = nil;
    if (self.drawSClassCard) {
        arm = [ArmFactory createNewMusketeerWithSpecificCategory:S_Class];
    } else {
        arm = [ArmFactory createNewMusketeer];
    }
    
    self.nameLabel.text = @"火槍兵";
    ArmCategory category = [arm category];
    NSString *categoryStr = nil;
    switch (category) {
        case S_Class:
            categoryStr = @"S";
            break;
        case A_Class:
            categoryStr = @"A";
            break;
        case B_Class:
            categoryStr = @"B";
            break;
        case C_Class:
            categoryStr = @"C";
            break;
        case D_Class:
            categoryStr = @"D";
            break;
        case E_Class:
            categoryStr = @"E";
            break;
    }
    
    self.categoryLabel.text = categoryStr;
    self.atkLabel.text = [NSString stringWithFormat:@"%@%lld", @"ATK:", arm.atk];
    
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:[[DBManager sharedInstance] getTotalPower] forCategory:@"com.irons.PirateHegemonyOnline"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dimissButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
