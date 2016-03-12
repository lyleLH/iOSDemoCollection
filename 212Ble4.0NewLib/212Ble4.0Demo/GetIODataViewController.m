//
//  GetIODataViewController.m
//  212B_New
//
//  Created by 梁科 on 14-12-8.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import "GetIODataViewController.h"
#include "Obd3Prtl_Lib.h"
#import "SBJson.h"
#import "BLEController.h"
#import "uLog.h"
#define OBD_deviceID @"OBD_deviceId"  //保存设备的ID
#define OBD_dataNUM @"OBD_dataNumber" //保存设备的dataNUM

@interface GetIODataViewController ()<BLEControllerDelegate>
{
    // 蓝牙
    BLEController *bleController;
}
@end

@implementation GetIODataViewController
@synthesize check200EData;
@synthesize checkStaticData;
@synthesize checkAllData;
@synthesize receiveDataTV;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bleController = [BLEController getInstance];
    
    self.title = @"IOData-Test";
    
    check200EData.layer.cornerRadius = 5.0;
    checkStaticData.layer.cornerRadius = 5.0;
    checkAllData.layer.cornerRadius = 5.0;
    
    [check200EData setTitle:NSLocalizedString(@"只查看工况数据", nil)   forState:UIControlStateNormal];
    [checkStaticData setTitle: NSLocalizedString(@"只查看固定上传", nil) forState:UIControlStateNormal];
    [checkAllData setTitle: NSLocalizedString(@"查看所有接收的数据", nil)  forState:UIControlStateNormal];
    
    
    receiveDataTV.layer.cornerRadius = 8.0;
    checkType = 0;
    
    
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


#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    bleController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    bleController.delegate = nil;
}


-(IBAction)showFixData:(id)sender;
{
    receiveDataTV.text = NULL;
    checkType = 1;
}
-(IBAction)show200EData:(id)sender;
{
    receiveDataTV.text = NULL;
    checkType = 2;
}
-(IBAction)showAllEData:(id)sender;
{
    receiveDataTV.text = NULL;
    checkType = 0;
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


-(void)showReceiveDataByPerPackage:(NSString *)perPackageString
{
    NSDictionary *jdata = [perPackageString JSONValue];
    NSString *result = [jdata objectForKey:@"result"];
    NSString *instruction = [jdata objectForKey:@"instruction"];
    ALogDebug(@"instruction == %@",instruction);
    int ac = [result intValue];
    ALogDebug(@"result=%i", ac);
    if (checkType == 1) {
        if (ac == 4) {
            //记录下来当前的设备ID
            NSString *deviceId = [jdata objectForKey:@"deviceId"];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:deviceId forKey:OBD_deviceID];
            [userDefault synchronize];
            
            //固定上传包，需要记录下来包号 dataNumber
            NSString *dataNum = [jdata objectForKey:@"dataNumber"];
            [userDefault setObject:dataNum forKey:OBD_dataNUM];
            [userDefault synchronize];
            
            ALogDebug(@"dataForOBD行程数据=%@",jdata);
            receiveDataTV.text = [NSString stringWithFormat:@"result=%d\n%@",ac,jdata];
        }
    }
    else if (checkType == 2){
        if (ac == 5) {
            //为终端主动上传的实时工况数据，输出数据结构与API_Send_iOBD()一致
            ALogDebug(@"dataForOBD实时工况数据=%@",jdata);
            receiveDataTV.text = [NSString stringWithFormat:@"result=%d\n%@",ac,jdata];
        }
    }
    else{
        if (ac == 0) {
            //回应登录包
            NSData *loginData = [self stringToByte:instruction];
            ALogDebug(@"loginData=%@",loginData);
            [self writeDataTo212B:loginData];
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
        receiveDataTV.text = [NSString stringWithFormat:@"result=%d\n%@",ac,jdata];
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
        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i];
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48);
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55;
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;
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


@end
