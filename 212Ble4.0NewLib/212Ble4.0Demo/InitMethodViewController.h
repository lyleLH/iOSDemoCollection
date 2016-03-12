//
//  InitMethodViewController.h
//  212B_New
//
//  Created by 梁科 on 14-12-8.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEController.h"
@interface InitMethodViewController : UIViewController<UIAlertViewDelegate>
{
   
    NSString * deviceID;
    NSString *dataNUM;
}
@property(retain,nonatomic) IBOutlet UIButton *startInit;

@property(retain,nonatomic) IBOutlet UITextField *deviceIdFiled;
@property(retain,nonatomic) IBOutlet UITextField *dataNumFiled;

-(IBAction) startInit:(id)sender;
@end
