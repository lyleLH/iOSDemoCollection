//
//  FixedparametersViewController.m
//  212B_New
//
//  Created by 梁科 on 14-12-9.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import "FixedparametersViewController.h"
#include "Obd3Prtl_Lib.h"
#import "SBJson.h"
#import "BLEController.h"
#define OBD_deviceID @"OBD_deviceId"  //保存设备的ID
#define OBD_dataNUM @"OBD_dataNumber" //保存设备的dataNUM
#import "uLog.h"
@interface FixedparametersViewController ()<BLEControllerDelegate>
{
    // 蓝牙
    BLEController *bleController;
}
@end

@implementation FixedparametersViewController
@synthesize GPSSwitch;
@synthesize OBDSwitch;
@synthesize G_SenserSwitch;
@synthesize SendTimeTF;
@synthesize OBDGetTimeTF;
@synthesize OBDGetTypeTF;
@synthesize ApiResponeTV;
@synthesize OBD_ResponeTV;

@synthesize GPRSSwitchLable;
@synthesize OBDSwitchLable;
@synthesize G_SensorSwitchLable;
@synthesize FixedUploadTimeLable;
@synthesize PIDSampledTimeLable;
@synthesize PIDSampledTypesLable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bleController = [BLEController getInstance];
    
    
    
    self.title = @"固定上传类参数";
    SendTimeTF.delegate = self;
    OBDGetTimeTF.delegate = self;
    OBDGetTypeTF.delegate = self;
    ApiResponeTV.layer.cornerRadius = 8.0;
    OBD_ResponeTV.layer.cornerRadius = 8.0;
    
    GPRSSwitchLable.text = NSLocalizedString(@"GPRS数据开关", nil);
    OBDSwitchLable.text = NSLocalizedString(@"OBD工况数据开关", nil);
    G_SensorSwitchLable.text = NSLocalizedString(@"G-Sensor数据开关", nil);
    FixedUploadTimeLable.text = NSLocalizedString(@"固定上传时间间隔", nil);
    PIDSampledTimeLable.text = NSLocalizedString(@"工况数据采集时间间隔", nil);
    PIDSampledTypesLable.text = NSLocalizedString(@"工况数据采集类型", nil);
    OBDGetTypeTF.placeholder = NSLocalizedString(@"多个类型请以逗号隔开", nil);
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    bleController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    bleController.delegate = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([SendTimeTF isFirstResponder]) {
        [SendTimeTF resignFirstResponder];
    }
    if ([OBDGetTimeTF isFirstResponder]) {
        [OBDGetTimeTF resignFirstResponder];
    }
    if ([OBDGetTypeTF isFirstResponder]) {
        [OBDGetTypeTF resignFirstResponder];
    }
}
-(IBAction)startSet:(id)sender;
{
    ApiResponeTV.text = NULL;
    OBD_ResponeTV.text = NULL;
    
    NSMutableString *setDataStr = [NSMutableString stringWithCapacity:0];
    if (GPSSwitch.on == YES) {
        [setDataStr appendFormat:@"01;"];
    }else{
        [setDataStr appendFormat:@"00;"];
    }
    if (OBDSwitch.on == YES) {
        [setDataStr appendFormat:@"01;"];
    }else{
        [setDataStr appendFormat:@"00;"];
    }
    if (G_SenserSwitch.on == YES) {
        [setDataStr appendFormat:@"01;"];
    }else{
        [setDataStr appendFormat:@"00;"];
    }
    //固定上传时间
    if ([SendTimeTF.text intValue]>3600 || [SendTimeTF.text intValue]<10) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil)  message: NSLocalizedString(@"请输入10-3600之间的数据", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSString *SendTimeStr = SendTimeTF.text;
    [setDataStr appendFormat:@"%@",SendTimeStr];
    [setDataStr appendFormat:@";"];
    
    //工况数据采集时间间隔
    
    int OBDGetTime = [OBDGetTimeTF.text intValue];
    ALogDebug(@"OBDGetTime = %d",OBDGetTime);
    
    if ([OBDGetTimeTF.text intValue] != 2 ) {
        if ([OBDGetTimeTF.text intValue] != 10) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil)  message: NSLocalizedString(@"请输入2或者10", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    
    
    
    NSString *OBDGetTimeStr = OBDGetTimeTF.text;
    [setDataStr appendFormat:@"%@",OBDGetTimeStr];
    [setDataStr appendFormat:@";"];
    
    
    //OBD工况数据采集类型
    NSString *getTypestr = [OBDGetTypeTF text];
    [setDataStr appendFormat:@"%@",getTypestr];
    
    
    
    //上传的类型
    NSString *getStrDataTpye = [NSString stringWithFormat:@"1201,1202,1203,1204,1205,1206"];
    const char *dataTpye = [getStrDataTpye UTF8String];
    ALogDebug(@"dataTpye=%s",dataTpye);
    const char *value = [setDataStr UTF8String];
    ALogDebug(@"value=%s",value);
    
    char *resultData = setParameter((char *)dataTpye, (char *)value);
    ALogDebug(@"resultData=%s",resultData);
    
    ApiResponeTV.text = [NSString stringWithFormat:@"%s",resultData];
    
    if (resultData != NULL) {
        NSString *myStrting = [NSString stringWithCString: resultData encoding:NSUTF8StringEncoding];
        NSDictionary *data = [myStrting JSONValue];
        NSString *str = [data objectForKey:@"instruction"];
        
        NSData *writeData = [self stringToByte:str];
        
        ALogDebug(@"writeData=%@",writeData);
        
        [self writeDataTo212B:writeData];
    }


    if ([SendTimeTF isFirstResponder]) {
        [SendTimeTF resignFirstResponder];
    }
    if ([OBDGetTimeTF isFirstResponder]) {
        [OBDGetTimeTF resignFirstResponder];
    }
    if ([OBDGetTypeTF isFirstResponder]) {
        [OBDGetTypeTF resignFirstResponder];
    }
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
    // ALogDebug(@"instruction == %@",instruction);
    int ac = [result intValue];
    ALogDebug(@"result=%i", ac);
    if (ac == 0) {
        //回应登录包
        NSData *loginData = [self stringToByte:instruction];
        ALogDebug(@"loginData=%@",loginData);
        [self writeDataTo212B:loginData];
    }
    else if (ac == 2) {
        //控制、设置参数回应
        ALogDebug(@"dataSetParameter=%@",jdata);
        OBD_ResponeTV.text = [NSString stringWithFormat:@"%@",jdata];
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

#pragma mark-UITextField Delegate
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //加上 64 因为有导航栏
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 + 64 - (self.view.frame.size.height - 216.0);//iPhone键盘高度216，iPad的为352
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
