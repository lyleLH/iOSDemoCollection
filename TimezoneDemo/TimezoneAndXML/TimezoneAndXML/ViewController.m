//
//  ViewController.m
//  TimezoneAndXML
//
//  Created by 刘浩 on 15/7/23.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import "ViewController.h"
#import "HTTimezoneTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [HTTimezoneTool getTimezoneIdByCompareLocalTimezoneWithTimezoneList];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
