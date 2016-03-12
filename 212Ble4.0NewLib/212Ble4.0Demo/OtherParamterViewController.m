//
//  OtherParamterViewController.m
//  212Ble4.0Demo
//
//  Created by 梁科 on 15-1-7.
//  Copyright (c) 2015年 castel. All rights reserved.
//

#import "OtherParamterViewController.h"
#include "Obd3Prtl_Lib.h"
#import "SBJson.h"
#import "BLEController.h"
#define OBD_deviceID @"OBD_deviceId"  //保存设备的ID
#define OBD_dataNUM @"OBD_dataNumber" //保存设备的dataNUM
#import "uLog.h"

@interface OtherParamterViewController ()<BLEControllerDelegate,UITextFieldDelegate>
{
    // 蓝牙
    BLEController *bleController;
}
@end

@implementation OtherParamterViewController

@synthesize OBD_ID;

@synthesize displacementTF;
@synthesize oilTypeTF;
@synthesize licencePlateTF;
@synthesize numberTF;
@synthesize RTCtimeTF;
@synthesize engineMissesTimeDelayTF;
@synthesize ApiResponeTV;
@synthesize OBD_ResponeTV;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    bleController =[BLEController getInstance];
    
    ApiResponeTV.layer.cornerRadius = 8.0;
    OBD_ResponeTV.layer.cornerRadius =8.0;
    
    displacementTF.delegate = self;
    oilTypeTF.delegate = self;
    licencePlateTF.delegate = self;
    numberTF.delegate = self;
    RTCtimeTF.delegate = self;
    engineMissesTimeDelayTF.delegate = self;
    
    /*
     NSString *str = @"粤B12345";
     
     //a47c 4200 3100 3200 3300 3400 3500
     NSString *hexStr = [self hexStringFromString:str];
     ALogDebug(@"hexStr==%@",hexStr);
     
     
     NSMutableString *allString=[[NSMutableString alloc] initWithCapacity:0];
     for(int i=0;i<[hexStr length];i=i+4){
     
     NSString *subString;
     
     if (i==0) {
     subString = [hexStr substringWithRange:NSMakeRange(i, 4)];
     NSString *NewStrsubString= [self stringFromHexString:subString];
     [allString appendString:NewStrsubString];
     ALogDebug(@"subString = %@",NewStrsubString);
     }
     else{
     subString = [hexStr substringWithRange:NSMakeRange(i, 2)];
     
     int subInt ;
     sscanf(subString.UTF8String, "%x",&subInt);
     NSString *hexString = [NSString stringWithFormat:@"%c",subInt];
     [allString appendString:hexString];
     ALogDebug(@"hexString = %@",hexString);
     
     }
     }
     ALogDebug( @"allString =%@",allString);
     
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//设油耗
-(IBAction)checkoilwear:(id)sender;{
    ApiResponeTV.text = NULL;
    OBD_ResponeTV.text = NULL;
    
    NSMutableString *setDataStr = [NSMutableString stringWithCapacity:0];
    if (displacementTF.text == NULL ||  displacementTF.text.length == 0 ) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示" , nil) message:NSLocalizedString(@"请输入排量", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    [setDataStr appendFormat:@"%@",displacementTF.text];
    [setDataStr appendFormat:@","];
    if (oilTypeTF.text == NULL ||  oilTypeTF.text.length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示" , nil) message:NSLocalizedString(@"请输入燃油类型", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    [setDataStr appendFormat:@"%@",oilTypeTF.text];
    
    
    //上传的类型
    NSString *getStrDataTpye = [NSString stringWithFormat:@"1401"];
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
    if ([displacementTF isFirstResponder]) {
        [displacementTF resignFirstResponder];
    }if ([oilTypeTF isFirstResponder]) {
        [oilTypeTF resignFirstResponder];
    }
    
}

//设车牌
-(IBAction)checklicencePlate:(id)sender;
{
    
    ApiResponeTV.text = NULL;
    OBD_ResponeTV.text = NULL;
    
    NSMutableString *setDataStr = [NSMutableString stringWithCapacity:0];
    if (licencePlateTF.text == NULL ||  licencePlateTF.text.length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入车牌号", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ( licencePlateTF.text.length > 7 ) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"输入非法", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [setDataStr appendFormat:@"%@",licencePlateTF.text];
    
    
    //上传的类型
    NSString *getStrDataTpye = [NSString stringWithFormat:@"1501"];
    const char *dataTpye = [getStrDataTpye UTF8String];
    ALogDebug(@"dataTpye=%s",dataTpye);
    
    
    //将车牌转换为 车牌号要求为UTF-16编码
    NSString *hexStrLicencePlate = [self hexStringFromString:setDataStr];
    
    ALogDebug(@"hexStrLicencePlate = %@",hexStrLicencePlate);
    
    const char *value = [hexStrLicencePlate UTF8String];
    
    ALogDebug(@"hexStrLicencePlateValue = %s",value);
    
    
    
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
    
    if ([licencePlateTF isFirstResponder]) {
        [licencePlateTF resignFirstResponder];
    }
    
}
//设置序列号
-(IBAction) setNumber:(id)sender;{
    
    ApiResponeTV.text = NULL;
    OBD_ResponeTV.text = NULL;
    
    NSMutableString *setDataStr = [NSMutableString stringWithCapacity:0];
    if (numberTF.text == NULL ||  numberTF.text.length == 0 ) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入序列号", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    [setDataStr appendFormat:@"%@",numberTF.text];
    
    
    //上传的类型
    NSString *getStrDataTpye = [NSString stringWithFormat:@"1601"];
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
    
    if ([numberTF isFirstResponder]) {
        [numberTF resignFirstResponder];
    }
    
}
//设置RTC时间
-(IBAction) setRTCtime:(id)sender;
{
    
    
    ApiResponeTV.text = NULL;
    OBD_ResponeTV.text = NULL;
    
    NSMutableString *setDataStr = [NSMutableString stringWithCapacity:0];
    if (RTCtimeTF.text == NULL ||  RTCtimeTF.text.length == 0 ) {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入RTC时间", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    [setDataStr appendFormat:@"%@",RTCtimeTF.text];
    
    
    //上传的类型
    NSString *getStrDataTpye = [NSString stringWithFormat:@"1A01"];
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
    if ([RTCtimeTF isFirstResponder]) {
        [RTCtimeTF resignFirstResponder];
    }
}
//设置发动机延时
-(IBAction) setengineMissesTimeDelay:(id)sender;
{
    ApiResponeTV.text = NULL;
    OBD_ResponeTV.text = NULL;
    
    NSMutableString *setDataStr = [NSMutableString stringWithCapacity:0];
    if (engineMissesTimeDelayTF.text == NULL ||  engineMissesTimeDelayTF.text.length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入发动机熄火延时判断时间", nil)  delegate:self cancelButtonTitle: NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    [setDataStr appendFormat:@"%@",engineMissesTimeDelayTF.text];
    
    
    //上传的类型
    NSString *getStrDataTpye = [NSString stringWithFormat:@"1D01"];
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
    
    if ([engineMissesTimeDelayTF isFirstResponder]) {
        [engineMissesTimeDelayTF resignFirstResponder];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([displacementTF isFirstResponder]) {
        [displacementTF resignFirstResponder];
    }
    if ([oilTypeTF isFirstResponder]) {
        [oilTypeTF resignFirstResponder];
    }
    if ([licencePlateTF isFirstResponder]) {
        [licencePlateTF resignFirstResponder];
    }
    if ([numberTF isFirstResponder]) {
        [numberTF resignFirstResponder];
    }
    if ([RTCtimeTF isFirstResponder]) {
        [RTCtimeTF resignFirstResponder];
    }if ([engineMissesTimeDelayTF isFirstResponder]) {
        [engineMissesTimeDelayTF resignFirstResponder];
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


// Data was received from the accessory, real apps should do something with this data but currently:
//    1. bytes counter is incremented
//    2. bytes are read from the session controller and thrown away
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
    NSString *deviceId = [jdata objectForKey:@"deviceId"];
    NSString *instruction = [jdata objectForKey:@"instruction"];
    ALogDebug(@"instruction == %@",instruction);
    OBD_ID = deviceId;
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
        ALogDebug(@"dataSetParameter2=%@",jdata);
        OBD_ResponeTV.text = [NSString stringWithFormat:@"%@",jdata];
    }
    else if (ac == 3) {
        //为终端主动上传修改过的参数或参数查询响应
        ALogDebug(@"dataSetParameter3=%@",jdata);
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



#pragma-mark 用于车牌的转换
//普通字符串转换为十六进制的。

-(NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF16LittleEndianStringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString {
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:NSUTF16LittleEndianStringEncoding];
    ALogDebug(@"------字符串=======%@",unicodeString);
    return unicodeString;
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

@end
