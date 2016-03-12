//
//  AlermTypeViewController.h
//  212B_New
//
//  Created by 梁科 on 14-12-9.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sendTypeProtocol.h"
@interface AlermTypeViewController : UIViewController<sendTypeProtocol>
{
    NSString *getStrDataTpye;
    
}




@property(nonatomic,retain) NSString *getStrDataTpye;


@property(nonatomic,retain) IBOutlet UILabel *alertEanbleLable;
@property(nonatomic,retain) IBOutlet UILabel *alertBeepLable;
@property(nonatomic,retain) IBOutlet UILabel *alertThresholdLable;

@property(nonatomic,retain) IBOutlet UITextField *alertInfo;

@property(retain,nonatomic)IBOutlet UISwitch *enableSwitch;
@property(retain,nonatomic)IBOutlet UISwitch *soundSwitch;
@property(retain,nonatomic)IBOutlet UITextField *alermValueTF;

@property(retain,nonatomic)IBOutlet UITextView *resultTV;
@property(retain,nonatomic)IBOutlet UITextView *OBD_resultTV;

@property(retain,nonatomic)IBOutlet UIButton *startSetBtn;
-(IBAction)startSet:(id)sender;
@end
