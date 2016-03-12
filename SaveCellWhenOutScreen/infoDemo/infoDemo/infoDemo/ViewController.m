//
//  ViewController.m
//  infoDemo
//
//  Created by 刘浩 on 15/7/8.
//  Copyright (c) 2015年 castel. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UITableView* tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,strong)NSMutableArray * lableTitle;
@property (nonatomic,strong)NSMutableDictionary * dicToCommit;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate  = self;
    self.tableView.dataSource =self;
    
    
    [self.view addSubview:self.tableView];
    [self initData];
    
    
}

- (void)initData  {
    
    
    _dataSource = [[NSMutableArray alloc]initWithArray: @[@"name",@"age",@"sex",@"A",@"B",@"C",@"D",@"E",@"F",@"G"]];
    _dicToCommit = [[NSMutableDictionary alloc] initWithCapacity:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell) {
        
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:nil options:nil];
        cell = objects[0];
    }
    cell.labName.text  = _dataSource[indexPath.row];
    
    //
    //
    
    NSInteger row = indexPath.row;
    
    CGRect textFieldRect = CGRectMake(0.0, 10.0f, 250.0f, 50.0f);
    
    UITextField *theTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    
    theTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    theTextField.returnKeyType = UIReturnKeyDone;
    
    theTextField.secureTextEntry = NO;
    
    theTextField.clearButtonMode = YES;
    
    theTextField.tag = row;
    
    theTextField.delegate = self;
    
    theTextField.backgroundColor = [UIColor lightGrayColor];
    
    //关键方法
    
    [theTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];

    cell.accessoryView = theTextField;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    switch (row) {
            
        case 0:
            
            theTextField.text = @"what";
            
            break;
            
        case 1:
            
            theTextField.text = @"a";
            
            break;
            
        case 2:
            
            theTextField.text = @"wonderful";
            
            break;
        case 3:
            
            theTextField.text = @"day";
            
            break;
        case 4:
            
            theTextField.text = @"and";
            
            break;
        case 5:
            
            theTextField.text = @"something";
            
            break;
        case 6:
            
            theTextField.text = @"briliant";
            
            break;
        case 7:
            
            theTextField.text = @"should";
            
            break;
        case 8:
            
            theTextField.text = @"happen";
            
            break;
        case 9:
            
            theTextField.text = @"!";
            
            break;
            
            
        default:
            
            break;
    
   
    }
    
    return cell;

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}
    
- (void)textFieldWithText:(UITextField *)textField {
        
        switch (textField.tag) {
                
            case 0:
                
                [_dicToCommit setObject:textField.text forKey:@"name"];
                
                break;
                
            case 1:
                
                [_dicToCommit setObject:textField.text forKey:@"age"];
                
                break;
                
            case 2:
                
                
                [_dicToCommit setObject:textField.text forKey:@"sex"];
                break;
            case 3:
                
                
                [_dicToCommit setObject:textField.text forKey:@"A"];
                break;
            case 4:
                
                
                [_dicToCommit setObject:textField.text forKey:@"B"];
                break;
            case 5:
                
                
                [_dicToCommit setObject:textField.text forKey:@"C"];
                break;
            case 6:
                
                
                [_dicToCommit setObject:textField.text forKey:@"D"];
                break;
            case 7:
                
                
                [_dicToCommit setObject:textField.text forKey:@"E"];
                break;
            case 8:
                
                
                [_dicToCommit setObject:textField.text forKey:@"F"];
                break;
            case 9:
                
                
                [_dicToCommit setObject:textField.text forKey:@"G"];
                break;
                
            default:
                
                break;
                
        }
    NSLog(@"%@",_dicToCommit);
    }

@end
