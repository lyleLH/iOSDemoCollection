//
//  ViewController.m
//  SaveCellWhenOutScreen
//
//  Created by 刘浩 on 15/7/9.
//  Copyright (c) 2015年 castel. All rights reserved.
//

#import "ViewController.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    __weak UITableViewCell * _tabCell;
    
    NSMutableArray * _muArray;
    NSMutableArray * _endArray;
}

@property (nonatomic,strong)UITableView * tableView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _muArray = [NSMutableArray array];
    _endArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
    
}

int  count = 0;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = nil;
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        UITextField * texf = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREENWIDTH - 40, 50)];
        
        texf.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        
        texf.returnKeyType = UIReturnKeyDone;
        
        texf.backgroundColor = [UIColor cyanColor];
        
        texf.borderStyle = UITextBorderStyleRoundedRect;
        
        texf.secureTextEntry = NO;
        
        texf.clearButtonMode = YES;
        
        texf.delegate = self;
        
        cell.accessoryView = texf;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        if (indexPath.row == 0  || indexPath.row == 1 || indexPath.row == 2|| indexPath.row == 3) {
            
            [_muArray addObject:cell];

        }
 
        
    }

    if(indexPath.row == 0 ) {
        
        if (_tabCell != nil) {
            
            _tabCell = _muArray[0];
            
            return _tabCell;
            
        }
        
    }
    
    if(indexPath.row == 1 ) {
        
        if (_tabCell != nil) {
            
            _tabCell = _muArray[1];
            
            return _tabCell;
            
        }
        
    }
    if(indexPath.row == 2 ) {
        
        if (_tabCell != nil) {
            
            _tabCell = _muArray[2];
            
            return _tabCell;
            
        }
        
    }
    if(indexPath.row == 3 ) {
        
        if (_tabCell != nil) {
            
            _tabCell = _muArray[3];
            
            return _tabCell;
            
        }
        
    }
    

    
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2|| indexPath.row == 3) {
        
        _tabCell = cell;
        
    }

    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
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
