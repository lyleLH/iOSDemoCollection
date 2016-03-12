//
//  GetParametorViewController.m
//  212B_New
//
//  Created by 梁科 on 14-12-8.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import "GetParametorViewController.h"
#include "Obd3Prtl_Lib.h"
#import "SBJson.h"
#import "BLEController.h"
#define OBD_deviceID @"OBD_deviceId"  //保存设备的ID
#define OBD_dataNUM @"OBD_dataNumber" //保存设备的dataNUM
#import "uLog.h"

#define mainScreenHeight  [[UIScreen mainScreen]bounds].size.height
#define mainScreenWidth  [[UIScreen mainScreen]bounds].size.width
@interface GetParametorViewController ()<BLEControllerDelegate>
{
    // 蓝牙
    BLEController *bleController;
}
@end



@implementation GetParametorViewController
@synthesize selectTypeBtn;
@synthesize queryBtn;

@synthesize queryType;

@synthesize showType;
@synthesize showAPI_Response;
@synthesize showOBD_Response;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.title = @"Parametor-Test";
    
    bleController = [BLEController getInstance];
    
    tableSource= [[NSMutableArray alloc]initWithObjects: NSLocalizedString(@"查询告警参数", nil),NSLocalizedString(@"查询固定上传参数", nil),NSLocalizedString(@"查询油耗参数", nil),NSLocalizedString(@"查询车牌号", nil),NSLocalizedString(@"查询终端序列号", nil),NSLocalizedString(@"查询终端RTC时间", nil),NSLocalizedString(@"查询系统提示音状态", nil),NSLocalizedString(@"查询发动机熄火延时判断", nil),NSLocalizedString(@"查询车辆VIN码", nil),NSLocalizedString(@"查询软硬件版本", nil),NSLocalizedString(@"查询车辆支持的OBD数据流", nil), nil];
    
    queryType = [[NSString alloc]init];
    
    showAPI_Response.layer.cornerRadius = 8.0;
    showOBD_Response.layer.cornerRadius = 8.0;
    queryBtn.layer.cornerRadius = 5.0;
    selectTypeBtn.layer.cornerRadius = 5.0;
    
}


-(IBAction)selectType:(id)sender;
{

    sourceTab = [[UITableView alloc]initWithFrame:CGRectMake(10, 180, mainScreenWidth-20, mainScreenHeight-200) style:UITableViewStylePlain];
    
    sourceTab.dataSource = self;
    sourceTab.delegate = self;
    [self.view addSubview:sourceTab];

  
    
}
-(IBAction)startQuery:(id)sender;
{
    
    
    if ([sourceTab isDescendantOfView:self.view]) {
        [sourceTab removeFromSuperview];
    }
    
    if (queryType.length==0) {
        return;
    }
    showAPI_Response.text = NULL;
    showOBD_Response.text = NULL;
    
    NSString *strTpye = queryType;
    const char *dataTpye = [strTpye UTF8String];
    ALogDebug(@"dataTpye=%s",dataTpye);
    
    char *resultData = getParameter((char *)dataTpye);
    ALogDebug(@"resultData=%s",resultData);
    
    showAPI_Response.text = [NSString stringWithFormat:@"%s",resultData];
    
    if (resultData != NULL) {
        NSString *myStrting = [NSString stringWithCString: resultData encoding:NSUTF8StringEncoding];
        NSDictionary *data = [myStrting JSONValue];
        NSString *str = [data objectForKey:@"instruction"];
        ALogDebug(@"instruction == %@",str);
        
        NSData *writeData = [self stringToByte:str];
        
        ALogDebug(@"writeData=%@",writeData);
        
        [self writeDataTo212B:writeData];
    }
}

#pragma mark- UITableView_Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [tableSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [tableSource objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    return cell;

}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
 
    showType.text = [tableSource objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
            queryType = @"10";
            break;
        case 1:
            queryType = @"12";
            break;
        case 2:
            queryType = @"14";//or 1401
            break;
        case 3:
            queryType = @"15";//or 1501
            break;
        case 4:
            queryType = @"16";//or 1601
            break;
        case 5:
            queryType = @"1A";//or 1A01
            break;
        case 6:
            queryType = @"1B";//or 1B01
            break;
        case 7:
            queryType = @"1D";//or 1D01
            break;
        case 8:
            queryType = @"22";//or 2201
            break;
        case 9:
            queryType = @"23";//or 2301
            break;
        case 10:
            queryType = @"24";//or 2401
            break;
            
        default:
            break;
    }
    
    if ([sourceTab isDescendantOfView:self.view]) {
        [sourceTab removeFromSuperview];
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
    ALogDebug(@"instruction == %@",instruction);
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
    }
    else if (ac == 3) {
        //为终端主动上传修改过的参数或参数查询响应
        ALogDebug(@"dataSetParameter=%@",jdata);
        
        showOBD_Response.text = [NSString stringWithFormat:@"%@",jdata];
        
        NSArray *chepaiArr = [jdata objectForKey:@"value"];
        NSDictionary *chePaiDic = [chepaiArr objectAtIndex:0];
        NSString *tlvTag = [chePaiDic objectForKey:@"tlvTag"];
        if ([tlvTag isEqualToString:@"1501"] || [tlvTag isEqualToString:@"15"]) {
            NSString *chePaiHexStr = [chePaiDic objectForKey:@"value"];
            NSString *chePai = [self getChePaiFromHexStr:chePaiHexStr];
            if (chePai.length !=0) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示" , nil) message:[NSString stringWithFormat:@"License plate number:%@",chePai] delegate:self cancelButtonTitle:NSLocalizedString( @"确定", nil) otherButtonTitles: nil];
                [alert show];
            }
        }
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


//转换车牌
-(NSString *)getChePaiFromHexStr: (NSString *)hexStr
{
    
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
    return allString;

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
@end
