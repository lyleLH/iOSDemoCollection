//
//  FixedparametersViewController.h
//  212B_New
//
//  Created by 梁科 on 14-12-9.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixedparametersViewController : UIViewController<UITextFieldDelegate>
{}

@property(retain,nonatomic)IBOutlet UILabel *GPRSSwitchLable;
@property(retain,nonatomic)IBOutlet UILabel *OBDSwitchLable;
@property(retain,nonatomic)IBOutlet UILabel *G_SensorSwitchLable;
@property(retain,nonatomic)IBOutlet UILabel *FixedUploadTimeLable;
@property(retain,nonatomic)IBOutlet UILabel *PIDSampledTimeLable;
@property(retain,nonatomic)IBOutlet UILabel *PIDSampledTypesLable;


@property(nonatomic,retain)IBOutlet UISwitch *GPSSwitch;
@property(nonatomic,retain)IBOutlet UISwitch *OBDSwitch;
@property(nonatomic,retain)IBOutlet UISwitch *G_SenserSwitch;

@property(nonatomic,retain)IBOutlet UITextField *SendTimeTF;
@property(nonatomic,retain)IBOutlet UITextField *OBDGetTimeTF;
@property(nonatomic,retain)IBOutlet UITextField *OBDGetTypeTF;

@property(nonatomic,retain)IBOutlet UITextView *ApiResponeTV;
@property(nonatomic,retain)IBOutlet UITextView *OBD_ResponeTV;


-(IBAction)startSet:(id)sender;
@end
