//
//  SetCtrlViewController.h
//  212B_New
//
//  Created by 梁科 on 14-12-8.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEController.h"
@interface SetCtrlViewController : UIViewController<BLEControllerDelegate>
{
    // 蓝牙
    BLEController *bleController;
    
}

@property(retain,nonatomic)IBOutlet UIButton *cleanDTCBtn;
@property(retain,nonatomic)IBOutlet UIButton *cleanOBDBtn;
@property(retain,nonatomic)IBOutlet UIButton *reSetOBDBtn;
@property(retain,nonatomic)IBOutlet UIButton *recoverBtn;



-(IBAction)cleanDTCdata:(id)sender;
-(IBAction)cleanOBDdata:(id)sender;
-(IBAction)resetOBD:(id)sender;
-(IBAction)recoverOBD:(id)sender;

@property(nonatomic,retain)IBOutlet UITextView *resultDataTV;
@property(nonatomic,retain)IBOutlet UITextView *OBD_resultDataTV;

@end
