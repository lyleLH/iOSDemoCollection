//
//  BLEController.m
//  212Ble4.0Demo
//
//  Created by 梁科 on 14-12-11.
//  Copyright (c) 2014年 castel. All rights reserved.
//
#import "BLEController.h"
#import "uLog.h"

#define StoreOBDInfo    @"theInfoOBDIdentifierForNewAPI"
#define waitTime 2
@implementation BLEController
@synthesize delegate;
@synthesize _centralMan;
@synthesize _peripheral;

static BLEController *sharedController=nil;
- (id)init {
    self = [super init];
    if (self) {
        _centralMan=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
        peripheralArr=[[NSMutableArray alloc]init];
        waitCounter = 0;

    }
    return self;
}

//使用单列
+(BLEController *) getInstance{
    @synchronized(self){
        if (sharedController == nil) {
            sharedController = [[self alloc] init];
        }
    }
    return  sharedController;
}

//开始扫瞄
-(void)scanForPer{
 
        [_centralMan scanForPeripheralsWithServices:nil options:nil];
}


#pragma mark
#pragma CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    //判断一下手机蓝牙的状态，以便做出相应的动作
    ALogDebug(@"蓝牙状态:%ld",(long)central.state);
    if (central.state==CBCentralManagerStatePoweredOn) {
        
        [self scanForPer];
        _centralMan=central;
        [_centralMan scanForPeripheralsWithServices:nil options:nil]; //手机的蓝牙处于打开状态，开始扫描外设
        ALogDebug(@"\n开始扫描...");
        
    }
    else if (central.state==CBCentralManagerStateUnsupported){
        //你的设备不支持蓝牙4.0
        ALogDebug(@"你的设备不支持蓝牙4.0");
    }
    else if(central.state==CBCentralManagerStatePoweredOff )
    {
        ALogDebug(@"蓝牙未开启");
        [delegate systemCloseblue]; //系统的蓝牙处于关闭状态
    }
}



- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{

    ALogDebug(@"发现外围设备，并接受到广播数据");
    
    ALogDebug(@"advertisementData=%@",advertisementData);
    
    NSData *manufacturerData=[advertisementData valueForKey:CBAdvertisementDataManufacturerDataKey];
    NSString *ManufacturerString=[self receiveDataToString:manufacturerData];

    NSString *  CBAdvertisementDataLocalName = [advertisementData valueForKey:CBAdvertisementDataLocalNameKey];
    
    ALogDebug(@"CBAdvertisementDataLocalNameKey = %@",CBAdvertisementDataLocalName);
    
    _peripheral=peripheral;
    
    [delegate getCheckInfo:ManufacturerString];

    if ([CBAdvertisementDataLocalName isEqualToString:@"IDD-212"]) {
        
        
        NSString *OBDidentifier = [[peripheral identifier] UUIDString];
        
        ALogDebug(@"OBDidentifier = %@",OBDidentifier);
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *infoStr = [userDefault stringForKey:StoreOBDInfo];
        
        if ([infoStr length] == 0 || infoStr == NULL) {
            [userDefault setObject:OBDidentifier forKey:StoreOBDInfo];
            [userDefault synchronize];
            [_centralMan connectPeripheral:_peripheral options:Nil];
            if (_peripheral.state == CBPeripheralStateConnecting) {
                [_centralMan stopScan];
            }
        }
        else{
            
            if ([OBDidentifier isEqualToString:infoStr]) {
                [_centralMan connectPeripheral:_peripheral options:Nil];
                if (_peripheral.state == CBPeripheralStateConnecting) {
                    [_centralMan stopScan];
                }
            }
            
            else{
                NSTimer *countTimer;
                if (waitCounter < waitTime) {
                    countTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(waitCounterAdd) userInfo:nil repeats:YES];
                }else{
                    if ([countTimer isValid]) {
                        [countTimer invalidate];
                    }
                    [userDefault setObject:OBDidentifier forKey:StoreOBDInfo];
                    [userDefault synchronize];

                    [_centralMan connectPeripheral:_peripheral options:Nil];
                    if (_peripheral.state == CBPeripheralStateConnecting) {
                        [_centralMan stopScan];
                    }
                }
            }
        }
    }
}

-(void) waitCounterAdd
{
    waitCounter++;
}

/*
//定期读取外设的RSSI，暂时不用执行
- (void)noticeToReadRSSI{
    [_peripheral readRSSI];
    
    [self performSelector:@selector(noticeToReadRSSI) withObject:nil afterDelay:0.2];
}
bool readRssiFlag=NO;
*/


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    ALogDebug(@"连接到外围设备");
    /*
     //定期读取外设的RSSI
    if (readRssiFlag==NO) {
        [self noticeToReadRSSI];
        readRssiFlag=YES;
    }
     */
    _peripheral = peripheral;
    _peripheral.delegate = self;
    [_peripheral discoverServices:nil];//读取外设的服务信息
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
{
    ALogDebug(@"与外围设备连接失败");
    ALogDebug(@"Error Reason=%@",error);
}



- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    ALogDebug(@"与外围设备连接意外的断开");
    //设备意外的断开后，需要我们进行重连，除非是用户主动调用cancleconnection方法，则可以不调用重连方法
    if (error.code ==CBErrorConnectionTimeout) {
        [_centralMan connectPeripheral:_peripheral options:nil];
        [delegate breakConnect];
    }
    if (error.code==CBErrorOperationCancelled) {
        ALogDebug(@"用户主动取消蓝牙连接，不用回连");
    }
    if (error.code==CBErrorUnknown) {
        ALogDebug(@"已经和这台设备断开了连接：%@,原因是未知=%@",peripheral.name,error);
    }
    
    if (error.code==CBErrorPeripheralDisconnected) {
        ALogDebug(@"外设主动跟我断开了");
    }
    [_centralMan connectPeripheral:_peripheral options:nil];
}


#pragma mark-
#pragma mark-CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (int i=0; i < peripheral.services.count; i++) {
        CBService *s = [peripheral.services objectAtIndex:i];
        
        [peripheral discoverCharacteristics:nil forService:s]; //一次性读取外设的所有特征值
    }
   
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error;
{
    
     NSNumber *number=peripheral.RSSI;
    [delegate getRSSIforDevice:number];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        
        [peripheral setNotifyValue:YES forCharacteristic:c];
    }
    
    [delegate getNameAndUUID];
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    
    if ([[[characteristic UUID] UUIDString] isEqualToString:@"FFF1"]) {
        [delegate didUpdateValueForCBCharacteristicFFF1:characteristic];
    }
    
}


#pragma mark-Self—_Func
//转换接收的数据
-(NSString *)receiveDataToString:(NSData *)data{
    
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
