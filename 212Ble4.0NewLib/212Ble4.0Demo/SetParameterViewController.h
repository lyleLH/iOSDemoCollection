//
//  SetParameterViewController.h
//  212B_New
//
//  Created by 梁科 on 14-12-8.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import "SJBBaseTreeListViewController.h"
#import "sendTypeProtocol.h"

@interface SetParameterViewController : SJBBaseTreeListViewController
{
    id<sendTypeProtocol> _sendDataDelegate;
}

///创建自己的tableView和resultArray
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *myResultArray;
@property(assign)id<sendTypeProtocol> sendDataDelegate;
@end
