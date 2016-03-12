//
//  SJBBaseTreeListViewController.m
//  SJBTreeListTableView
//
//  Created by Buddy on 29/4/14.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SJBBaseTreeListViewController.h"
#define kSectionHeaderHeight 50.0f
@interface SJBBaseTreeListViewController ()

@end

@implementation SJBBaseTreeListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.treeOpenArray = [NSMutableArray array];
        self.sectionListName = [NSString stringWithFormat:@"name"];
        self.rowListTitle = [NSString stringWithFormat:@"country"];
        self.rowListName = [NSString stringWithFormat:@"cityName"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    ///下面是所需要的数据结构。
    NSMutableDictionary *typeDict1 = [NSMutableDictionary dictionary];
    [typeDict1 setObject: NSLocalizedString(@"超速告警", nil)  forKey:self.rowListName];
    NSMutableDictionary *typeDict2 = [NSMutableDictionary dictionary];
    [typeDict2 setObject: NSLocalizedString(@"低电压告警",nil) forKey:self.rowListName];
    NSMutableDictionary *typeDict3 = [NSMutableDictionary dictionary];
    [typeDict3 setObject:NSLocalizedString(@"水温告警" ,nil)forKey:self.rowListName];
    NSMutableDictionary *typeDict4 = [NSMutableDictionary dictionary];
    [typeDict4 setObject:NSLocalizedString(@"急加速告警",nil) forKey:self.rowListName];
    NSMutableDictionary *typeDict5 = [NSMutableDictionary dictionary];
    [typeDict5 setObject:NSLocalizedString(@"急减速告警",nil)  forKey:self.rowListName];
    NSMutableDictionary *typeDict6 = [NSMutableDictionary dictionary];
    [typeDict6 setObject:NSLocalizedString(@"停车未熄火告警",nil)   forKey:self.rowListName];
    NSMutableDictionary *typeDict7 = [NSMutableDictionary dictionary];
    [typeDict7 setObject:NSLocalizedString(@"拖吊告警",nil)  forKey:self.rowListName];
    NSMutableDictionary *typeDict8 = [NSMutableDictionary dictionary];
    [typeDict8 setObject:NSLocalizedString(@"转速高告警",nil)  forKey:self.rowListName];
    NSMutableDictionary *typeDict9 = [NSMutableDictionary dictionary];
    [typeDict9 setObject:NSLocalizedString(@"上电告警",nil)  forKey:self.rowListName];
    NSMutableDictionary *typeDict10 = [NSMutableDictionary dictionary];
    [typeDict10 setObject:NSLocalizedString(@"尾气超标告警",nil)  forKey:self.rowListName];
    NSMutableDictionary *typeDict11 = [NSMutableDictionary dictionary];
    [typeDict11 setObject:NSLocalizedString(@"急变道告警",nil)  forKey:self.rowListName];
    NSMutableDictionary *typeDict12 = [NSMutableDictionary dictionary];
    [typeDict12 setObject:NSLocalizedString(@"急转弯告警",nil)  forKey:self.rowListName];
    NSMutableDictionary *typeDict13 = [NSMutableDictionary dictionary];
    [typeDict13 setObject:NSLocalizedString(@"疲劳驾驶告警",nil) forKey:self.rowListName];
    NSMutableDictionary *typeDict14 = [NSMutableDictionary dictionary];
    [typeDict14 setObject:NSLocalizedString(@"碰撞告警",nil) forKey:self.rowListName];
    
    
    NSMutableArray *typeDicttion1 = [NSMutableArray arrayWithObjects:typeDict1,typeDict2,typeDict3,typeDict4,typeDict5,typeDict6,typeDict7,typeDict8,typeDict9,typeDict10,typeDict11,typeDict12,typeDict13,typeDict14, nil];
    NSMutableDictionary *countryDict1 = [NSMutableDictionary dictionaryWithObject:typeDicttion1 forKey:self.rowListTitle];
    [countryDict1 setObject: NSLocalizedString(@"告警类参数",nil) forKey:self.sectionListName];
    
    
    /*
    ///GPRS类参数
    NSMutableDictionary *typeDict21 = [NSMutableDictionary dictionary];
    [typeDict21 setObject:@"拨号方式" forKey:self.rowListName];
    NSMutableDictionary *typeDict22 = [NSMutableDictionary dictionary];
    [typeDict22 setObject:@"域名参数" forKey:self.rowListName];
    NSMutableDictionary *typeDict23 = [NSMutableDictionary dictionary];
    [typeDict23 setObject:@"IP地址" forKey:self.rowListName];
    NSMutableDictionary *typeDict24 = [NSMutableDictionary dictionary];
    [typeDict24 setObject:@"PORT端口号" forKey:self.rowListName];
    NSMutableDictionary *typeDict25 = [NSMutableDictionary dictionary];
    [typeDict25 setObject:@"APN参数" forKey:self.rowListName];
    NSMutableDictionary *typeDict26 = [NSMutableDictionary dictionary];
    [typeDict26 setObject:@"USER用户名" forKey:self.rowListName];
    NSMutableDictionary *typeDict27 = [NSMutableDictionary dictionary];
    [typeDict27 setObject:@"PASSWORD密码" forKey:self.rowListName];
    NSMutableArray *typeDicttion2 = [NSMutableArray arrayWithObjects:typeDict21,typeDict22,typeDict23,typeDict24,typeDict25, typeDict26,typeDict27,nil];
    NSMutableDictionary *countryDict2 = [NSMutableDictionary dictionaryWithObject:typeDicttion2 forKey:self.rowListTitle];
    [countryDict2 setObject:@"GPRS类参数" forKey:self.sectionListName];
     */
    
    
    ///固定上传类参数
    
    
    NSMutableDictionary *typeDict301 = [NSMutableDictionary dictionary];
    [typeDict301 setObject: NSLocalizedString(@"固定上传类参数",nil) forKey:self.rowListName];
    
    /*
    NSMutableDictionary *typeDict301 = [NSMutableDictionary dictionary];
    [typeDict301 setObject:@"GPS数据开关" forKey:self.rowListName];
    NSMutableDictionary *typeDict302 = [NSMutableDictionary dictionary];
    [typeDict302 setObject:@"OBD工况数据开关" forKey:self.rowListName];
    NSMutableDictionary *typeDict303 = [NSMutableDictionary dictionary];
    [typeDict303 setObject:@"G-Sensor数据开关" forKey:self.rowListName];
    NSMutableDictionary *typeDict304 = [NSMutableDictionary dictionary];
    [typeDict304 setObject:@"固定上传时间间隔" forKey:self.rowListName];
    NSMutableDictionary *typeDict305 = [NSMutableDictionary dictionary];
    [typeDict305 setObject:@"OBD工况数据采集时间间隔" forKey:self.rowListName];
    NSMutableDictionary *typeDict306 = [NSMutableDictionary dictionary];
    [typeDict306 setObject:@"OBD工况数据采集类型" forKey:self.rowListName];
    */
    /*
    NSMutableDictionary *typeDict307 = [NSMutableDictionary dictionary];
    [typeDict307 setObject:@"省电模式" forKey:self.rowListName];
    NSMutableDictionary *typeDict308 = [NSMutableDictionary dictionary];
    [typeDict308 setObject:@"油耗参数" forKey:self.rowListName];
    NSMutableDictionary *typeDict309 = [NSMutableDictionary dictionary];
    [typeDict309 setObject:@"车牌号" forKey:self.rowListName];
    NSMutableDictionary *typeDict310 = [NSMutableDictionary dictionary];
    [typeDict310 setObject:@"终端序列号" forKey:self.rowListName];
    NSMutableDictionary *typeDict311 = [NSMutableDictionary dictionary];
    [typeDict311 setObject:@"短信手机用户号码" forKey:self.rowListName];
    NSMutableDictionary *typeDict312 = [NSMutableDictionary dictionary];
    [typeDict312 setObject:@"短信维护密钥" forKey:self.rowListName];
    NSMutableDictionary *typeDict313 = [NSMutableDictionary dictionary];
    [typeDict313 setObject:@"短信语言" forKey:self.rowListName];
    NSMutableDictionary *typeDict314 = [NSMutableDictionary dictionary];
    [typeDict314 setObject:@"终端RTC时间" forKey:self.rowListName];
    NSMutableDictionary *typeDict315 = [NSMutableDictionary dictionary];
    [typeDict315 setObject:@"系统提示音状态" forKey:self.rowListName];
    NSMutableDictionary *typeDict316 = [NSMutableDictionary dictionary];
    [typeDict316 setObject:@"睡眠下固定上传间隔" forKey:self.rowListName];
    NSMutableDictionary *typeDict317 = [NSMutableDictionary dictionary];
    [typeDict317 setObject:@"发动机熄火延时判断" forKey:self.rowListName];
    */
    
   // NSMutableArray *typeDicttion3 = [NSMutableArray arrayWithObjects:typeDict301,typeDict302,typeDict303,typeDict304,typeDict305, typeDict306,nil];
    
    NSMutableArray *typeDicttion3 = [NSMutableArray arrayWithObjects:typeDict301,nil];
    
    
    NSMutableDictionary *countryDict3 = [NSMutableDictionary dictionaryWithObject:typeDicttion3 forKey:self.rowListTitle];
    [countryDict3 setObject:NSLocalizedString(@"固定上传类参数",nil) forKey:self.sectionListName];
    
    
    ///其它类参数
    
    NSMutableDictionary *typeDict401 = [NSMutableDictionary dictionary];
    [typeDict401 setObject:NSLocalizedString(@"其它类参数",nil) forKey:self.rowListName];

    /*
    NSMutableDictionary *typeDict401 = [NSMutableDictionary dictionary];
    [typeDict401 setObject:@"油耗参数" forKey:self.rowListName];
    NSMutableDictionary *typeDict402 = [NSMutableDictionary dictionary];
    [typeDict402 setObject:@"车牌号" forKey:self.rowListName];
    NSMutableDictionary *typeDict403 = [NSMutableDictionary dictionary];
    [typeDict403 setObject:@"设置序列号" forKey:self.rowListName];
    NSMutableDictionary *typeDict404 = [NSMutableDictionary dictionary];
    [typeDict404 setObject:@"RTC时间" forKey:self.rowListName];
    NSMutableDictionary *typeDict405 = [NSMutableDictionary dictionary];
    [typeDict405 setObject:@"发动机熄火延时判断" forKey:self.rowListName];
    */
    /*
    NSMutableDictionary *typeDict406 = [NSMutableDictionary dictionary];
    [typeDict406 setObject:@"车辆VIN码" forKey:self.rowListName];
    NSMutableDictionary *typeDict407 = [NSMutableDictionary dictionary];
    [typeDict407 setObject:@"终端软硬件版本" forKey:self.rowListName];
    
    NSMutableDictionary *typeDict408 = [NSMutableDictionary dictionary];
    [typeDict408 setObject:@"车辆支持的OBD数据流" forKey:self.rowListName];
    */
    //NSMutableArray *typeDicttion4 = [NSMutableArray arrayWithObjects:typeDict401,typeDict402,typeDict403,typeDict404,typeDict405, nil];
    
    NSMutableArray *typeDicttion4 = [NSMutableArray arrayWithObjects:typeDict401, nil];
    
    NSMutableDictionary *countryDict4 = [NSMutableDictionary dictionaryWithObject:typeDicttion4 forKey:self.rowListTitle];
    [countryDict4 setObject:NSLocalizedString(@"其它类参数",nil) forKey:self.sectionListName];
    
    
    
    self.treeResultArray = [NSMutableArray arrayWithObjects:countryDict1,countryDict3,countryDict4,nil];
    
    ///原来下面几句都在viewDidLoad 里面，所以很卡。。。
    if (self.treeTableView==nil||self.treeTableView==NULL) {
        self.treeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
        self.treeTableView.delegate = self;
        self.treeTableView.dataSource = self;
        self.treeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:self.treeTableView];
        if ([self.treeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.treeTableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - =================自己写的tableView================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.treeResultArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int tempNum = (int)[[self.treeResultArray[section]objectForKey:self.rowListTitle] count];
    NSString *tempSectionString = [NSString stringWithFormat:@"%ld",(long)section];
    if ([self.treeOpenArray containsObject:tempSectionString]) {
        return tempNum;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *tempV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
    tempV.backgroundColor = [UIColor colorWithRed:(236)/255.0f green:(236)/255.0f blue:(236)/255.0f alpha:1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 2, 200, 30)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont fontWithName:@"Arial" size:20];
    label1.text = [self.treeResultArray[section] objectForKey:self.sectionListName];
    
    UIImageView *tempImageV = [[UIImageView alloc]initWithFrame:CGRectMake(286, 20, 20, 11)];
    NSString *tempSectionString = [NSString stringWithFormat:@"%ld",(long)section];
    if ([self.treeOpenArray containsObject:tempSectionString]) {
        tempImageV.image = [UIImage imageNamed:@"close"];
        
    }else{
        tempImageV.image = [UIImage imageNamed:@"open"];
    }
    ///给section加一条线。
    CALayer *_separatorL = [CALayer layer];
    _separatorL.frame = CGRectMake(0.0f, 49.0f, [UIScreen mainScreen].bounds.size.width, 1.0f);
    _separatorL.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    [tempV addSubview:label1];
    [tempV addSubview:tempImageV];
    [tempV.layer addSublayer:_separatorL];
    
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(0, 0, 320, 50);
    [tempBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    tempBtn.tag = section;
    [tempV addSubview:tempBtn];
    return tempV;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSectionHeaderHeight;
}

-(void)tapAction:(UIButton *)sender{
    self.treeOpenString = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if ([self.treeOpenArray containsObject:self.treeOpenString]) {
        [self.treeOpenArray removeObject:self.treeOpenString];
    }else{
        [self.treeOpenArray addObject:self.treeOpenString];
    }
    ///下面一句是用的时候刷新的。
    //    [self.treeTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
}

///这个都没有执行。。。
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///下面这是类似section里面
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [[[self.treeResultArray[indexPath.section]objectForKey:self.rowListTitle] objectAtIndex:indexPath.row] objectForKey:self.rowListName];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.numberOfSections == 0) {
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
