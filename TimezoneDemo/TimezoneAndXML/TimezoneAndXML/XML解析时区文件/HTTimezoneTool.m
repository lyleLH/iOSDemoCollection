//
//  HTTimezoneTool.m
//  GpsTracker
//
//  Created by 刘浩 on 15/7/23.
//  Copyright (c) 2015年 LiuHao. All rights reserved.
//

#import "HTTimezoneTool.h"
#import "SHXMLParser.h"


@implementation HTTimezoneTool



+ (NSDictionary *)getContenDicFromXmlFile {
    
    NSString *strPathXml = [[NSBundle mainBundle] pathForResource:@"timeZoneList" ofType:@"xml"];
    //将xml文件转换成data类型
    NSData * xmlData = [[NSData alloc] initWithContentsOfFile:strPathXml];
    
    SHXMLParser * parser = [[SHXMLParser alloc] init];
    
    NSDictionary * dic = [parser parseData:xmlData];
    
    NSDictionary * secDic = dic[@"items"];
    
    return secDic;
}

+ (NSArray * )getTimeZoneIDArrayFromDic {

    NSDictionary * secDic =  [self getContenDicFromXmlFile];
    
    NSArray * ary = secDic[@"item"];

    NSMutableArray *aryTimeZoneID = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSDictionary * dic in ary ) {

        NSString * timeZoneID = dic[@"id"];

        [aryTimeZoneID addObject:timeZoneID];
        
    }
    return aryTimeZoneID;
    
}

+ (NSArray * )getTimezoneNameArrayFromDic
{
    
    NSDictionary * secDic =  [self getContenDicFromXmlFile];
    
    NSArray * ary = secDic[@"item"];
    
    NSMutableArray *aryTimeZoneList = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSDictionary * dic in ary ) {
        
        NSString *timeZone =dic[@"leafContent"];

        [aryTimeZoneList addObject:timeZone];
  
    }
    
    return aryTimeZoneList;
    
}


+ (NSInteger )getTimezoneIdByCompareLocalTimezoneWithTimezoneList {
    
   NSArray *aryTimeZoneList =  [self getTimezoneNameArrayFromDic];

    //得到时间差 比较两个时间差

    NSTimeZone * timezoneLocal = [NSTimeZone localTimeZone];
    
    NSInteger i = [timezoneLocal secondsFromGMTForDate:[NSDate date]];
    
    NSInteger index = 1 ;
    
    for(index= 1 ; index <aryTimeZoneList.count-1;index ++) {
        
        NSString * strOrigin= aryTimeZoneList[index];
        
        NSRange  range = NSMakeRange(1, 9);
        
        NSString * timezoneStr = [strOrigin substringWithRange:range]; //@"GMT+08:30"
        
        NSTimeZone * timezoneFile =[NSTimeZone timeZoneWithName:timezoneStr];
        
       NSInteger j =  [timezoneFile secondsFromGMTForDate:[NSDate date]];
        
        if(i == j ) {
            
            return index;
        }

    }
    
    return 0;
}


@end
