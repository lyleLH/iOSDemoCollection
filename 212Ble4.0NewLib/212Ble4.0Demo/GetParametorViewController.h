//
//  GetParametorViewController.h
//  212B_New
//
//  Created by 梁科 on 14-12-8.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetParametorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *sourceTab;
    NSMutableArray *tableSource;
    
}

@property(retain,nonatomic) IBOutlet UIButton *selectTypeBtn;
@property(retain,nonatomic) IBOutlet UIButton *queryBtn;


@property(retain,nonatomic)NSString *queryType;
@property(retain,nonatomic) IBOutlet UITextField *showType;


@property(retain,nonatomic) IBOutlet UITextView *showAPI_Response;
@property(retain,nonatomic) IBOutlet UITextView *showOBD_Response;

-(IBAction)selectType:(id)sender;
-(IBAction)startQuery:(id)sender;

@end
