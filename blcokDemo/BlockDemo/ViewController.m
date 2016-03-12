//
//  ViewController.m
//  BlockDemo
//
//  Created by lyle on 15/7/15.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import "ViewController.h"

typedef NSString * (^ConstructString)(double);

@interface ViewController ()

@property (nonatomic,strong)ViewController2 * vc2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     *  blcok基本语法
     */
    NSString* (^myBlock)(NSString*, int);
    
    myBlock = ^(NSString *name, int age){
        
        return [NSString stringWithFormat:@"My name is %@,I'm %d years old!",name,age];
    };
    NSString *str = myBlock(@"胡晓伟",31);
    NSLog(@"%@",str);

    
    /**
     接下来是block反向传值的实验
     
     */
    
    /**
     标签来显示回传值
     */
    UILabel * mark = [[UILabel alloc] initWithFrame:CGRectMake(30, 64, 300, 40)];
    mark.backgroundColor = [UIColor brownColor];
    [self.view addSubview:mark];
    
    
    /**
     *  button to push
     */
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(100, 200, 100, 100)];
    self.view.backgroundColor = [UIColor orangeColor];
    btn.backgroundColor = [UIColor cyanColor];
    [btn setTitle:@"PUSH ->" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    
    /**
     实例化一个控制器，给自己 的属性vc2赋值
     */
    
    _vc2 = [[ViewController2 alloc] init];
    
    /**
     *  定义vc2的属性

     */
    _vc2.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.4 alpha:1];
    
    /**
     *  下面定义 vc2中的 block属性的 执行的block的 函数体
     *
     */
    _vc2.whatTheFuck = ^(NSInteger a,NSInteger b) {
        
        NSInteger so = a*b;
        
        NSLog(@"so fuck a * b :%ld",so);
        
    };
    
    
    _vc2.hell = ^(NSInteger a,NSInteger b) {
      
        NSLog(@"hell ..  a + b  :%ld",a + b);
    };
    

    __weak typeof(self) weakSelf = self;
    
    _vc2.useName = ^(UITextField * texf) {
      
        NSLog(@"%@",texf.text);
        mark.text = texf.text;
        weakSelf.name = mark.text;
        NSLog(@"self.nameIn with weak:%@",weakSelf.name);
//        NSLog(@"self.nameOut withOut weak:%@",self.name);    此处会造成内存泄漏
    };
    
    NSLog(@"self.nameOut:%@",self.name);  //此处为空值，blcok是异步执行的
   
}


- (void)push {
    
    [self presentViewController:_vc2 animated:YES completion:^{
        self.view.backgroundColor = _vc2.view.backgroundColor ;
        
    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
