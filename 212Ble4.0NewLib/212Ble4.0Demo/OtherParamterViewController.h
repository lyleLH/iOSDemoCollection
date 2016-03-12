//
//  OtherParamterViewController.h
//  212Ble4.0Demo
//
//  Created by 梁科 on 15-1-7.
//  Copyright (c) 2015年 castel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherParamterViewController : UIViewController
@property(retain,nonatomic)IBOutlet NSString *OBD_ID;

@property(retain,nonatomic)IBOutlet UITextField *displacementTF;
@property(retain,nonatomic)IBOutlet UITextField *oilTypeTF;
-(IBAction)checkoilwear:(id)sender;

@property (retain,nonatomic)IBOutlet UITextField *licencePlateTF;
-(IBAction)checklicencePlate:(id)sender;

@property(retain,nonatomic)IBOutlet UITextField *numberTF;
-(IBAction) setNumber:(id)sender;

@property(retain,nonatomic)IBOutlet UITextField *RTCtimeTF;
-(IBAction) setRTCtime:(id)sender;

@property(retain,nonatomic)IBOutlet UITextField *engineMissesTimeDelayTF;
-(IBAction) setengineMissesTimeDelay:(id)sender;

@property(nonatomic,retain)IBOutlet UITextView *ApiResponeTV;
@property(nonatomic,retain)IBOutlet UITextView *OBD_ResponeTV;

@end
