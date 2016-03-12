//
//  BLEController.h
//  212Ble4.0Demo
//
//  Created by 梁科 on 14-12-11.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>


/*一下的协议部分主要是用于把蓝牙4.0接收到的数据（如RSSI，电池电量，接收的外设发送的数据等）传给UI界面*/

@protocol BLEControllerDelegate <NSObject>


-(void) getCheckInfo:(NSString *)manuFaCtureInfo;
-(void) getNameAndUUID;
-(void) breakConnect;//当外设连接成功后，断开连接时调用，以便给UI通知
-(void) didUpdateValueForCBCharacteristicFFF1:(CBCharacteristic *)characteristic;//
-(void) getRSSIforDevice: (NSNumber *) DeviceRSSI;//该方法用于获取外设的RSSI
-(void) systemCloseblue;//




@end


@interface BLEController : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate> {
    
    
    id<BLEControllerDelegate> _delegate;
    
    NSString *devicePeripheralUUID;//设备的UUID
    NSMutableArray *peripheralArr;
    CBPeripheral *currentPeripheral;
    NSTimer *sendCheckDataTimer;
    
    int waitCounter;
    
}
+(BLEController *) getInstance;

@property(assign, nonatomic) id<BLEControllerDelegate> delegate;
@property(strong, nonatomic) CBCentralManager *_centralMan;
@property(strong, nonatomic) CBPeripheral *_peripheral;

@end
