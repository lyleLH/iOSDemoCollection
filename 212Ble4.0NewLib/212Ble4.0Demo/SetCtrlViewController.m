//
//  SetCtrlViewController.m
//  212B_New
//
//  Created by 梁科 on 14-12-8.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import "SetCtrlViewController.h"
#include "Obd3Prtl_Lib.h"
#import "SBJson.h"
#import "uLog.h"
#define OBD_deviceID @"OBD_deviceId"  //保存设备的ID
#define OBD_dataNUM @"OBD_dataNumber" //保存设备的dataNUM

@interface SetCtrlViewController ()
{
   
}
@end

@implementation SetCtrlViewController
@synthesize resultDataTV;
@synthesize OBD_resultDataTV;

@synthesize cleanDTCBtn;@synthesize cleanOBDBtn;@synthesize recoverBtn;@synthesize reSetOBDBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Ctrl-Test";
    
    
    bleController=[BLEController getInstance];
    bleController.delegate = self;
    
    resultDataTV.layer.cornerRadius = 8.0;
    OBD_resultDataTV.layer.cornerRadius = 8.0;
    
    cleanDTCBtn.layer.cornerRadius = 5.0;
    cleanOBDBtn.layer.cornerRadius = 5.0;
    recoverBtn.layer.cornerRadius = 5.0;
    reSetOBDBtn.layer.cornerRadius = 5.0;
    
    [cleanDTCBtn setTitle:NSLocalizedString(@"清除DTC数据", nil) forState:UIControlStateNormal];
    [cleanOBDBtn setTitle:NSLocalizedString(@"清空OBD数据区", nil) forState:UIControlStateNormal];
    [recoverBtn setTitle:NSLocalizedString(@"重置OBD设备", nil) forState:UIControlStateNormal];
    [reSetOBDBtn setTitle:NSLocalizedString(@"恢复出厂设置", nil) forState:UIControlStateNormal];
    
}




-(void)viewWillAppear:(BOOL)animated
{

    bleController.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    bleController.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreate    d.
}


#pragma mark-BLEController.Delegate

-(void) getCheckInfo:(NSString *)manuFaCtureInfo;//用于获取外设广播包里面的相关数据
{
    ALogDebug(@"manuFaCtureInfo = %@",manuFaCtureInfo);
}

-(void) getNameAndUUID;//主要用于获取外设的设备名称
{}
-(void) breakConnect;//当外设连接成功后，断开连接时调用，以便给UI通知
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) didUpdateValueForCBCharacteristicFFF1:(CBCharacteristic *)characteristic;
{
    ALogDebug(@"characteristic.value=%@",characteristic.value);
    
    NSData *receiveDataFrom212b = characteristic.value;
    NSString *dataToString = [self receiveDataToString:receiveDataFrom212b];
    const char * receiveCharFrom212b = [dataToString UTF8String];
    ALogDebug(@"receiveCharFrom212b = %s",receiveCharFrom212b);
    char *receiveDataToChar = getIOData((char *)receiveCharFrom212b);
    if(receiveDataToChar!=NULL){
        NSString *charToStrting = [NSString stringWithCString: receiveDataToChar encoding:NSUTF8StringEncoding];
        receiveDataToChar = NULL;
        NSArray *strArr = [charToStrting componentsSeparatedByString:@"&"];
        for (int i = 0; i<[strArr count]; i++) {
            NSString *subStr = [strArr objectAtIndex:i];
            [self showReceiveDataByPerPackage:subStr];
        }
    }
}

-(void)showReceiveDataByPerPackage : (NSString *)receiveStr
{
    NSDictionary *jdata = [receiveStr JSONValue];
    NSString *result = [jdata objectForKey:@"result"];
    //NSString *deviceId = [jdata objectForKey:@"deviceId"];
    NSString *instruction = [jdata objectForKey:@"instruction"];
    // ALogDebug(@"instruction == %@",instruction);
    int ac = [result intValue];
    ALogDebug(@"result=%i", ac);
    if (ac == 0) {
        //回应登录包
        
        NSData *loginData = [self stringToByte:instruction];
        [self writeDataTo212B:loginData];
    }
    else if (ac == 2) {
        //控制、设置参数回应
        ALogDebug(@"dataSetParameter=%@",jdata);
        OBD_resultDataTV.text = [NSString stringWithFormat:@"%@",jdata];
        
    }
    else if (ac == 3) {
        //为终端主动上传修改过的参数或参数查询响应
        ALogDebug(@"dataSetParameter=%@",jdata);
    }
    else if (ac == 4) {
        //固定上传包
        
        //记录下来当前的设备ID
        NSString *deviceId = [jdata objectForKey:@"deviceId"];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:deviceId forKey:OBD_deviceID];
        [userDefault synchronize];
        
        //固定上传包，需要记录下来包号 dataNumber
        NSString *dataNum = [jdata objectForKey:@"dataNumber"];
        [userDefault setObject:dataNum forKey:OBD_dataNUM];
        [userDefault synchronize];
        
    }
    else if (ac == 5) {
        //为终端主动上传的实时工况数据，输出数据结构与API_Send_iOBD()一致
        ALogDebug(@"dataForOBD实时工况数据=%@",jdata);
    }
    else if (ac == 6) {
        //为APP执行监控指令后终端上传OBD数据
        ALogDebug(@"dataForOBD实时工况数据=%@",jdata);
    }
}

-(void) getRSSIforDevice: (NSNumber *) DeviceRSSI;//该方法用于获取外设的RSSI
{}
-(void) systemCloseblue;//该方法用于当用户在正常使用App时，突然自己关掉手机的蓝牙的回调
{}

-(void)writeDataTo212B :(NSData *)writeData
{
    if (bleController._peripheral.state==CBPeripheralStateConnected) {
        for (int i=0; i<bleController._peripheral.services.count; i++) {
            CBService *cbp=[bleController._peripheral.services objectAtIndex:i];
            if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFF0"]]) {
                for (int j=0; j<cbp.characteristics.count; j++) {
                    CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                    if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
                        [bleController._peripheral writeValue:writeData forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                        ALogDebug(@"已经发送包了");
                    }
                }
            }
        }
    }
    else if (bleController._peripheral.state==CBPeripheralStateDisconnected  || bleController._peripheral.state==CBPeripheralStateConnecting)
    {
        ALogDebug(@"蓝牙没有连接上");
    }
}


#pragma mark-NSStringToByte
-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

//转换接收的数据
-(NSString *)receiveDataToString:(NSData *)data
{
    int dataLength =(int) data.length;
    const unsigned char *hexBytesLight = [data bytes];
    NSString *receivedataStr=@"";
    for (int i=0; i<dataLength; i++) {
        NSString *dataLengthStr=[NSString stringWithFormat:@"%02x",hexBytesLight[i]];
        receivedataStr=[receivedataStr stringByAppendingString:dataLengthStr];
    }
    return receivedataStr;
}

-(IBAction)cleanDTCdata:(id)sender;
{
    resultDataTV.text = NULL;
    OBD_resultDataTV.text = NULL;
    
    
    char *cleandata = setCtrl(0x01);
    resultDataTV.text = [NSString stringWithFormat:@"%s",cleandata];
    if (cleandata != NULL) {
        NSString *myStrting = [NSString stringWithCString: cleandata encoding:NSUTF8StringEncoding];
        NSDictionary *data = [myStrting JSONValue];
        NSString *str = [data objectForKey:@"instruction"];
        NSData *writeData = [self stringToByte:str];
        ALogDebug(@"wri=%@",writeData);
        [self writeDataTo212B:writeData];
    }
}


-(IBAction)cleanOBDdata:(id)sender;
{
    resultDataTV.text = NULL;
    OBD_resultDataTV.text = NULL;
    
    char *cleandata = setCtrl(0x02);
    resultDataTV.text = [NSString stringWithFormat:@"%s",cleandata];
    if (cleandata != NULL) {
        NSString *myStrting = [NSString stringWithCString: cleandata encoding:NSUTF8StringEncoding];
        NSDictionary *data = [myStrting JSONValue];
        NSString *str = [data objectForKey:@"instruction"];
        NSData *writeData = [self stringToByte:str];
        ALogDebug(@"wri=%@",writeData);
        [self writeDataTo212B:writeData];
    }
}
-(IBAction)resetOBD:(id)sender;
{
    resultDataTV.text = NULL;
    OBD_resultDataTV.text = NULL;
    
    char *cleandata = setCtrl(0x03);
    resultDataTV.text = [NSString stringWithFormat:@"%s",cleandata];
    if (cleandata != NULL) {
        NSString *myStrting = [NSString stringWithCString: cleandata encoding:NSUTF8StringEncoding];
        NSDictionary *data = [myStrting JSONValue];
        NSString *str = [data objectForKey:@"instruction"];
        NSData *writeData = [self stringToByte:str];
        ALogDebug(@"wri=%@",writeData);
        [self writeDataTo212B:writeData];
    }
}
-(IBAction)recoverOBD:(id)sender;
{
    resultDataTV.text = NULL;
    OBD_resultDataTV.text = NULL;
    
    char *cleandata = setCtrl(0x04);
    resultDataTV.text = [NSString stringWithFormat:@"%s",cleandata];
    if (cleandata != NULL) {
        NSString *myStrting = [NSString stringWithCString: cleandata encoding:NSUTF8StringEncoding];
        NSDictionary *data = [myStrting JSONValue];
        NSString *str = [data objectForKey:@"instruction"];
        NSData *writeData = [self stringToByte:str];
        ALogDebug(@"wri=%@",writeData);
       [self writeDataTo212B:writeData];
    }
}

@end
