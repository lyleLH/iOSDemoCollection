//
//  SetParameterViewController.m
//  212B_New
//
//  Created by 梁科 on 14-12-8.
//  Copyright (c) 2014年 castel. All rights reserved.
//

#import "SetParameterViewController.h"
#import "AlermTypeViewController.h"
#import "FixedparametersViewController.h"
#import "OtherParamterViewController.h"
#import "uLog.h"
@interface SetParameterViewController ()

@end

@implementation SetParameterViewController
@synthesize sendDataDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"请选择参数类型", nil);
    
    ///这里的resultArray可以根据需求自己定义。
    self.myResultArray = [NSMutableArray arrayWithArray:self.treeResultArray];
    ///这里的tableView可以根据需求自己定义。
    self.myTableView = self.treeTableView;
    self.treeTableView.delegate = self;
    self.treeTableView.dataSource = self;
}





#pragma mark - =================自己写的tableView================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.myResultArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ///这里需要根据自己的resulArray数据结构重写父类了。
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [super tableView:tableView viewForHeaderInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [super tableView:tableView heightForHeaderInSection:section];
}

-(void)tapAction:(UIButton *)sender{
    
    [super tapAction:sender];
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
}

///这个都没有执行。。。
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *strDataType;
    AlermTypeViewController *alermTypeVC = [[AlermTypeViewController alloc]init];
    FixedparametersViewController *fixedParaVC = [[FixedparametersViewController alloc]init];
    OtherParamterViewController *otherParaVC = [[OtherParamterViewController alloc]init];
    
    
    ALogDebug(@"indexPath.section == %ld",indexPath.section);
 
    ALogDebug(@"indexPath.row == %ld",indexPath.row);
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                //1001 超速告警
                strDataType = @"1001";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;

            case 1:
                //1002 低电压告警
                strDataType = @"1002";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 2:
                //1003 水温告警
                strDataType = @"1003";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 3:
                //1004 急加速告警
                strDataType = @"1004";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 4:
                //1005 急减速告警
                strDataType = @"1005";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 5:
                //1006 停车未熄火告警
                strDataType = @"1006";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 6:
                //1007 拖吊告警
                strDataType = @"1007";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 7:
                //1008 转速高告警
                strDataType = @"1008";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 8:
                //1009 上电告警
                strDataType = @"1009";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 9:
                //100A 尾气超标告警
                strDataType = @"100A";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 10:
                //100B 急变道告警
                strDataType = @"100B";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 11:
                //100C 急转弯告警
                strDataType = @"100C";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 12:
                //100D 疲劳驾驶告警
                strDataType = @"100D";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 13:
                //100E 碰撞告警
                strDataType = @"100E";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;

            default:
                break;
        }
        alermTypeVC.getStrDataTpye = strDataType;
        [self.navigationController pushViewController:alermTypeVC animated:YES];
    }
    else if (indexPath.section==1){
        
        /*
        switch (indexPath.row) {
            case 0:
                //1101 拨号方式
                strDataType = @"1101";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
                
            case 1:
                //1102 域名参数
                strDataType = @"1102";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 2:
                //1103 IP地址
                strDataType = @"1103";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 3:
                //1104 PORT 端口号
                strDataType = @"1104";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 4:
                //1105 APN 参数
                strDataType = @"1105";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 5:
                //1106 USER 用户名
                strDataType = @"1106";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                break;
            case 6:
                //1107 PASSWORD 密码
                strDataType = @"1107";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                break;
            default:
                break;
        }
         */
        switch (indexPath.row) {
            case 0:
                //1201 GPS数据开关
                strDataType = @"1201";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
                
            case 1:
                //1202 OBD工况数据开关
                strDataType = @"1202";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 2:
                //1203 G-Sensor数据开关
                strDataType = @"1203";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 3:
                //1204  固定上传时间间隔
                strDataType = @"1204";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 4:
                //1205 OBD工况数据采集时间间隔
                strDataType = @"1205";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                
                break;
            case 5:
                //1206 OBD工况数据采集类型
                strDataType = @"1206";
                [sendDataDelegate sendAlermTpyeData:strDataType];
                break;
            default:
                break;
        }
      
        [self.navigationController pushViewController:fixedParaVC animated:YES];
    }
    else if (indexPath.section==2){
         [self.navigationController pushViewController:otherParaVC animated:YES];
    }
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
