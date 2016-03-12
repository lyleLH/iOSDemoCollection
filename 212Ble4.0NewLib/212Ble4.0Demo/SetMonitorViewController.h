//
//  SetMonitorViewController.h
//  212B_New
//
//  Created by 梁科 on 14-12-8.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetMonitorViewController : UIViewController
{
  
}

@property(retain,nonatomic)IBOutlet UIButton *startBtn;

@property(nonatomic,retain)IBOutlet UITextView *resultTV;
@property(nonatomic,retain)IBOutlet UITextView *OBD_resultTV;
-(IBAction)startMonitor:(id)sender;
@end
