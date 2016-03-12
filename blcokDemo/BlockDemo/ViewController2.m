//
//  ViewController2.m
//  BlockDemo
//
//  Created by lyle on 15/7/15.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pop)];
    [self.view addGestureRecognizer:tap];
    self.texf = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    self.texf.backgroundColor = [UIColor cyanColor];
    self.view.backgroundColor = [UIColor orangeColor];
    

    [self.view addSubview:self.texf];
    
  
    
    if(_whatTheFuck) {
        
         _whatTheFuck(10,11);
    }
    if(_hell) {
        
        _hell(10,11);
    }
   
}
- (void)pop {
    if(_useName) {
        _useName(self.texf);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
   

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
