//
//  GetIODataViewController.h
//  212B_New
//
//  Created by 梁科 on 14-12-8.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetIODataViewController : UIViewController
{
    int checkType;
}

@property(retain,nonatomic)IBOutlet UIButton *checkStaticData;
@property(retain,nonatomic)IBOutlet UIButton *check200EData;
@property(retain,nonatomic)IBOutlet UIButton *checkAllData;

@property(retain,nonatomic) IBOutlet UITextView *receiveDataTV;


-(IBAction)showFixData:(id)sender;
-(IBAction)show200EData:(id)sender;
-(IBAction)showAllEData:(id)sender;
@end
