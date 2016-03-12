//
//  RootViewController.h
//  212Ble4.0Demo
//
//  Created by 梁科 on 14-12-11.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEController.h"
@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BLEControllerDelegate>{
 
    
    UILabel *isConnectLab;
    // 蓝牙
    BLEController *bleController;
    
    UITableView *tabView;
    
    NSString *OBD_ID;
}

@property (retain,nonatomic) UITableView *tabView;




@end
