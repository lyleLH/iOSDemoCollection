//
//  AlermTypeViewController.m
//  212B_New
//
//  Created by 梁科 on 14-12-9.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import "AlermTypeViewController.h"
#include "Obd3Prtl_Lib.h"
#import "SBJson.h"
#import "BLEController.h"
#import "uLog.h"
#define OBD_deviceID @"OBD_deviceId"  //保存设备的ID
#define OBD_dataNUM @"OBD_dataNumber" //保存设备的dataNUM

@interface AlermTypeViewController ()<BLEControllerDelegate>
{
    // 蓝牙
    BLEController *bleController;
}
@end

@implementation AlermTypeViewController
@synthesize getStrDataTpye;
@synthesize alertInfo;
@synthesize enableSwitch;
@synthesize soundSwitch;
@synthesize alermValueTF;
@synthesize resultTV;
@synthesize OBD_resultTV;
@synthesize startSetBtn;

@synthesize alertBeepLable;
@synthesize alertEanbleLable;
@synthesize alertThresholdLable;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bleController = [BLEController getInstance];
    
    
    alertEanbleLable.text = NSLocalizedString(@"报警使能", nil);
    alertBeepLable.text = NSLocalizedString(@"报警响声", nil);
    alertThresholdLable.text = NSLocalizedString(@"告警阀值", nil);
    
    
    self.title = getStrDataTpye;
    resultTV.layer.cornerRadius = 8.0;
    OBD_resultTV.layer.cornerRadius = 8.0;
    startSetBtn.layer.cornerRadius = 8.0;
    if ([getStrDataTpye isEqualToString: @"1001"]) {
        
        alertInfo.text =NSLocalizedString(@"超速告警阀值范围为：0-300",nil);
    }
    else if ([getStrDataTpye isEqualToString: @"1002"]){
        alertInfo.text = NSLocalizedString(@"低电压告警阀值范围为：9-36", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"1003"]){
        alertInfo.text = NSLocalizedString(@"水温告警阀值范围为：0-240", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"1004"]){
        alertInfo.text = NSLocalizedString(@"急加速告警阀值范围为：0.2-0.8", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"1005"]){
        alertInfo.text = NSLocalizedString(@"急减速告警阀值范围为：0.3-1.0", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"1006"]){
        alertInfo.text = NSLocalizedString(@"停车未熄火告警阀值范围为：1-30", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"1007"]){
        alertInfo.text = NSLocalizedString(@"拖吊告警阀值范围为：固定为 15", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"1008"]){
        alertInfo.text = NSLocalizedString(@"转速高告警阀值范围为：0-10000", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"1009"]){
        alertInfo.text = NSLocalizedString(@"上电告警阀值范围为：固定为 0", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"100A"]){
        alertInfo.text =  NSLocalizedString(@"尾气超标告警阀值范围为：固定为 0", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"100B"]){
        alertInfo.text =  NSLocalizedString(@"急变道告警阀值范围为：0.2-0.8", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"100C"]){
        alertInfo.text = NSLocalizedString(@"急转弯告警阀值范围为：0.3-0.9", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"100D"]){
        alertInfo.text = NSLocalizedString(@"疲劳驾驶告警阀值范围为：0-8", nil);
    }
    else if ([getStrDataTpye isEqualToString: @"100E"]){
        alertInfo.text = NSLocalizedString(@"碰撞告警阀值范围为：1.0-2.0", nil);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) sendAlermTpyeData:(NSString *)strType;
{
    
    
}
#warning 06.25 lh -- 设置时间间隔接口调用示例,不用调用
- (void)codeSnap {
    
    
    NSString *StrDataTpye = @"1204";//TLV_TAG:设置OBD工况采集间隔
    const char *dataTpye = [StrDataTpye UTF8String];
    
    NSMutableString *DataStr =[NSMutableString stringWithCapacity:0];
    [DataStr appendFormat:@"60"];//VALUE:间隔时间,秒
    const char *value = [DataStr UTF8String];
    
    char *resultData = setParameter((char *)dataTpye, (char *)value); //调用接口得到二进制指令
    
    NSString *myStrting = [NSString stringWithCString: resultData encoding:NSUTF8StringEncoding];
    
    NSDictionary *data = [myStrting  JSONValue]; //二进制指令得到Json
    
    NSString *str = [data objectForKey:@"instruction"];//取出指令字符串
    
    NSData *writeData = [self stringToByte:str];//指令转换为二进制数据流
    
    ALogDebug(@"writeData=%@",writeData);
    
    [self writeDataTo212B:writeData];// 写入OBD
    
}


-(IBAction)startSet:(id)sender;
{
    
    
    resultTV.text = NULL;
    OBD_resultTV.text = NULL;
    
    NSMutableString *setDataStr = [NSMutableString stringWithCapacity:0];
    
    if (enableSwitch.on==YES) {
       [setDataStr appendFormat:@"01,"];
    }else{
        [setDataStr appendFormat:@"00,"];
    }
    
    if (soundSwitch.on==YES) {
        [setDataStr appendFormat:@"01,"];
    }else{
        [setDataStr appendFormat:@"00,"];
    }
    
    if (alermValueTF.text.length == 0 || alermValueTF.text == NULL) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示" , nil) message:NSLocalizedString(@"请输入报警阀值", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
        [alert  show];
        return;
    }
    if (alermValueTF.text.length >5) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示" , nil) message:NSLocalizedString(@"输入过长，请重新输入", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
        [alert  show];
        return;
    }
    else{
        /*
        if (alermValueTF.text.length == 1) {
            [setDataStr appendFormat:@"000%@",alermValueTF.text];
        }
        else if (alermValueTF.text.length == 2){
            [setDataStr appendFormat:@"00%@",alermValueTF.text];
        }
        else if (alermValueTF.text.length == 3){
            [setDataStr appendFormat:@"0%@",alermValueTF.text];
        }
        else{
            [setDataStr appendFormat:@"%@",alermValueTF.text];
        }
         */
        [setDataStr appendFormat:@"%@",alermValueTF.text];
    }
    
    const char *dataTpye = [getStrDataTpye UTF8String];
    
    const char *value = [setDataStr UTF8String];
    
    char *resultData = setParameter((char *)dataTpye, (char *)value);
    
    resultTV.text = [NSString stringWithFormat:@"%s",resultData];
    
    
    
    if (resultData != NULL) {
        
        NSString *myStrting = [NSString stringWithCString: resultData encoding:NSUTF8StringEncoding];
        
        NSDictionary *data = [myStrting  JSONValue];
        
        NSString *str = [data objectForKey:@"instruction"];
        
        NSData *writeData = [self stringToByte:str];
        
        ALogDebug(@"writeData=%@",writeData);
        
        [self writeDataTo212B:writeData];
    }

    
    ALogDebug(@"setDataStr=%@",setDataStr);
    
    if ([alermValueTF isFirstResponder]) {
        [alermValueTF resignFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([alermValueTF isFirstResponder]) {
        [alermValueTF resignFirstResponder];
    }
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
        OBD_resultTV.text = [NSString stringWithFormat:@"%@",jdata];
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

@end
