//
//  ViewController.m
//  NSTimerDemo
//
//  Created by 刘浩 on 15/7/21.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    NSInteger _count;
    NSTimer * _threeTimesTimer;
    NSTimer * _backgroundTimer;
    
}

- (IBAction)btnFire:(UIButton *)sender;



@end


@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"呵呵");

    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    NSLog(@"哈哈");
    [self btnFire:nil];
}


- (IBAction)btnFire:(UIButton *)sender {
    
    
    _threeTimesTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                        target:self
                                                      selector:@selector(timeToGo)
                                                      userInfo:nil
                                                       repeats:YES];
}


- (void)timeToGo {

    _count ++;
    
    if(_count<2) {
        
        NSLog(@"调用次数");
        
    }
    else  if(_count==2) {
        
        [_threeTimesTimer invalidate];
        
       
        
        _threeTimesTimer = nil;
        
         [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        _backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                            target:self
                                                          selector:@selector(backToGo)
                                                          userInfo:nil
                                                           repeats:YES];
        
    } else {
        
        return;
    }
    

    NSLog(@"%ld",_count);
    
}



- (void)backToGo  {
    
    NSLog(@"哈啊哈") ;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    
    NSLog(@"霍霍");
}

@end
