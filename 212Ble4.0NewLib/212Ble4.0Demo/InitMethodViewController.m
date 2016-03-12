//
//  InitMethodViewController.m
//  212B_New
//
//  Created by 梁科 on 14-12-8.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import "InitMethodViewController.h"
#include "Obd3Prtl_Lib.h"
#import "uLog.h"



#define OBD_deviceID @"OBD_deviceId"  //保存设备的ID
#define OBD_dataNUM @"OBD_dataNumber" //保存设备的dataNUM


@interface InitMethodViewController ()
{
    
    
    
}
@end

@implementation InitMethodViewController
@synthesize startInit;

@synthesize deviceIdFiled;
@synthesize dataNumFiled;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    
    
    self.title = @"Init-Test";
    startInit.layer.cornerRadius = 5.0;
    
    deviceID = [[NSString alloc]init];
    
    dataNUM = [[NSString alloc]init];
    
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    
    deviceID = [defau stringForKey:OBD_deviceID];
    
    deviceIdFiled.text = deviceID;
    
    ALogDebug(@"deviceID =%@",deviceID);
    
    dataNUM = [defau stringForKey:OBD_dataNUM];
    
    dataNumFiled.text = dataNUM;
    
    ALogDebug(@"dataNUM =%@",dataNUM);
    
    
    if (deviceID == NULL) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示" , nil) message:NSLocalizedString(@"上次保存的设备ID为空，不能初始化，是否手动输入新的", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: NSLocalizedString( @"返回", nil),nil];
        [alert show];
        alert.tag = 100;
    }
    else if (dataNUM == NULL ){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示" , nil) message:NSLocalizedString(@"上次保存的dataNum为空，不能初始化，是否手动输入新的", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: NSLocalizedString( @"返回", nil),nil];
        [alert show];
        alert.tag = 101;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction) startInit:(id)sender;
{
    if ([deviceIdFiled isFirstResponder]) {
        [deviceIdFiled resignFirstResponder];
    }
    if ([dataNumFiled isFirstResponder]) {
        [dataNumFiled resignFirstResponder];
    }
    
    const char *device_ID = [deviceID UTF8String];
    const char *device_dataNum = [dataNUM UTF8String];
    int result = init((char *)device_ID,(char *)device_dataNum);
    
    if (result == -1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示" , nil) message:NSLocalizedString(@"初始化失败", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
        [alert show];
    }
    else if (result == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示" , nil) message:NSLocalizedString(@"初始化成功", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
        [alert show];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([deviceIdFiled isFirstResponder]) {
        [deviceIdFiled resignFirstResponder];
    }
    if ([dataNumFiled isFirstResponder]) {
        [dataNumFiled resignFirstResponder];
    }
}
#pragma mark-UIAlertView-Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{

    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 101){
        if (buttonIndex == 1) {
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
}

@end
