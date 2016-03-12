//
//  RootViewController.m
//  212Ble4.0Demo
//
//  Created by 梁科 on 14-12-11.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import "RootViewController.h"

#import "SBJson.h"
#import "Obd3Prtl_Lib.h"
#import "uLog.h"
#import "InitMethodViewController.h"
#import "SetCtrlViewController.h"
#import "SetMonitorViewController.h"
#import "SetParameterViewController.h"
#import "GetParametorViewController.h"
#import "GetIODataViewController.h"


#define OBD_deviceID @"OBD_deviceId"  //保存设备的ID
#define OBD_dataNUM @"OBD_dataNumber" //保存设备的dataNUM

#define ScreenSize [[UIScreen mainScreen] bounds].size
@interface RootViewController ()
{
    NSMutableArray *setMethodArr;
}
@end

@implementation RootViewController



@synthesize  tabView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
#warning lh -- 此处有严重错误 ，导致bleController的初始化存在问题，
//        bleController=[BLEController getInstance];

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
#pragma mark -- 初始化bleController之后立即设置代理，能让代理方法及时被监听到。- lh -- add
    bleController=[BLEController getInstance];
    bleController.delegate = self;
    
    setMethodArr = [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"初始化函数测试",nil),NSLocalizedString(@"控制函数测试",nil),NSLocalizedString(@"监控函数测试",nil),NSLocalizedString(@"参数设置函数测试",nil),NSLocalizedString(@"查询函数测试",nil),NSLocalizedString(@"业务数据交互函数测试",nil) , nil];
    
    
    isConnectLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20+44, ScreenSize.width, 40)];
    
    isConnectLab.text = @"OBD not connect...";
    
    isConnectLab.textAlignment =  NSTextAlignmentCenter;
    
    isConnectLab.font = [UIFont systemFontOfSize:24.0];
    
    [self.view addSubview:isConnectLab];
    
    
    tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, ScreenSize.width , ScreenSize.height-66) style:UITableViewStylePlain];
    
    tabView.dataSource =self;
    
    tabView.delegate = self;
    
    [self.view addSubview:tabView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if (bleController._peripheral.state == CBPeripheralStateConnected) {
        isConnectLab.text = @"OBD connected !";
    }else if (bleController._peripheral.state == CBPeripheralStateDisconnected){
        isConnectLab.text = @"OBD not connect...";
    }
    
    
    self.navigationController.navigationBarHidden = NO;
   
    bleController.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    bleController=[BLEController getInstance];
    bleController.delegate = nil;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [setMethodArr count];
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *eaAccessoryCellIdentifier = @"eaAccessoryCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eaAccessoryCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:eaAccessoryCellIdentifier];
    }
    
    
    [[cell textLabel] setText:[setMethodArr objectAtIndex:indexPath.row]];
    
    return cell;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ALogDebug(@"000.0000000");
    
    
        InitMethodViewController *initVC = [[InitMethodViewController alloc]init];
        SetCtrlViewController *setCtrlVC = [[SetCtrlViewController alloc] init];
        SetMonitorViewController *setMoniVC = [[SetMonitorViewController alloc]init];
        SetParameterViewController *setParaVC = [[SetParameterViewController alloc] init];
        GetParametorViewController *getParaVC = [[GetParametorViewController alloc]init];
        GetIODataViewController *getIODataVC = [[GetIODataViewController alloc]init];
    
        switch (indexPath.row) {
            case 0:
                [self.navigationController pushViewController:initVC animated:YES];
                 self.navigationController.navigationBarHidden = NO;
                break;
            case 1:
                [self.navigationController pushViewController:setCtrlVC animated:YES];
                  self.navigationController.navigationBarHidden = NO;
                break;
            case 2:
                [self.navigationController pushViewController:setMoniVC animated:YES];
                break;
            case 3:
                [self.navigationController pushViewController:setParaVC animated:YES];
                break;
            case 4:
                [self.navigationController pushViewController:getParaVC animated:YES];
                break;
            case 5:
                [self.navigationController pushViewController:getIODataVC animated:YES];
                break;
            default:
                break;
        }
    
}

#pragma mark-BLEController.Delegate

-(void) getCheckInfo:(NSString *)manuFaCtureInfo;//用于获取外设广播包里面的相关数据
{
    ALogDebug(@"manuFaCtureInfo = %@",manuFaCtureInfo);
}

-(void) getNameAndUUID;//主要用于获取外设的设备名称
{
     isConnectLab.text = @"OBD connected !";
    
}
-(void) breakConnect;//当外设连接成功后，断开连接时调用，以便给UI通知
{
     isConnectLab.text = @"OBD not connect...";
}



-(void) didUpdateValueForCBCharacteristicFFF1:(CBCharacteristic *)characteristic;
{
//    ALogDebug(@"characteristic.value=%@",characteristic.value);
    
    NSData *receiveDataFrom212b = characteristic.value;
    
    
    NSString *dataToString = [self receiveDataToString:receiveDataFrom212b];
    
    const char * receiveCharFrom212b = [dataToString UTF8String];
    
    
//    ALogDebug(@"receiveCharFrom212b = %s",receiveCharFrom212b);
    
    char *receiveDataToChar = getIOData((char *)receiveCharFrom212b);
#pragma mark -- 此处已经转换为可解析的Json数据
    
//    ALogDebug(@"receiveDataToChar = %s",receiveDataToChar);

    if(receiveDataToChar!=NULL){
        
        NSString *charToStrting = [NSString stringWithCString: receiveDataToChar encoding:NSUTF8StringEncoding];
//        ALogDebug(@"charToStrting = %@",charToStrting);
        receiveDataToChar = NULL;
        
        NSArray *strArr = [charToStrting componentsSeparatedByString:@"&"];
//        ALogDebug(@"strArr = %@",strArr);
        
        for (int i = 0; i<[strArr count]; i++) {
            
            NSString *subStr = [strArr objectAtIndex:i];
            ALogDebug(@"subStr = %@",subStr);
            [self showReceiveDataByPerPackage:subStr];
            
        }
        
    }
    
}

-(void)showReceiveDataByPerPackage : (NSString *)receiveStr
{
    
    NSDictionary *jdata = [receiveStr JSONValue];

    NSString *result = [jdata objectForKey:@"result"];
    
    NSString *instruction = [jdata objectForKey:@"instruction"];
    
    int ac = [result intValue];
    
    
    if(ac == 0){
        //登录包
        
        ALogDebug(@"recieveLoginData");
        NSData *loginData = [self stringToByte:instruction];
        
        [self writeDataTo212B:loginData];
        
    }
    if (ac==4) {
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
    
}


-(void) getRSSIforDevice: (NSNumber *) DeviceRSSI;//该方法用于获取外设的RSSI
{
}
-(void) systemCloseblue;//该方法用于当用户在正常使用App时，突然自己关掉手机的蓝牙的回调
{
    
}


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
                        ALogDebug(@"responseToLoginData,writeDataTo212B");
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
