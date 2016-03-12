//
//  ViewController.m
//  NSAssertDemo
//
//  Created by 刘浩 on 15/7/18.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong)UIButton * btn ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.btn.enabled = YES;
    
    
    
}
-(UIButton *)btn {
    
    if(_btn==nil) {
        
        _btn =[UIButton buttonWithType:UIButtonTypeCustom];
        
        [_btn setFrame:CGRectMake(20, 100, 200, 50)];
        
        [_btn setBackgroundColor:[UIColor orangeColor]];
        
        [_btn setTitle:@"点我生成随机数" forState:UIControlStateNormal];
        
        [_btn addTarget:self action:@selector(createRadomNumber:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_btn];
    }
    
    return _btn;
}

- (NSInteger )createRadomNumber:(UIButton *)btn {
    
   NSInteger random =  [self getRandomNumberFrom:0 To:50];
    NSLog(@"%ld",random);
    if(random<25) {
        
       NSAssert(random<25,@"x must not be >25");
    }
    else {
    
        return random;
    }
    
    return 0;
}

//获取一个随机整数，范围在[from,to），包括from，包括to
                 
 -(int)getRandomNumberFrom:(int)from To:(int)to
                 
{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
