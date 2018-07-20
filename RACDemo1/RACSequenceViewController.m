//
//  RACSequenceViewController.m
//  RACDemo1
//
//  Created by 王杰 on 2018/6/12.
//  Copyright © 2018年 车置宝. All rights reserved.
//

#import "RACSequenceViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSequenceViewController ()

@end

@implementation RACSequenceViewController

#pragma mark --- RACSequence RAC中的集合类
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        //RACSequence RAC
    //遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //字典
    NSDictionary *dict = @{@"name":@"张旭",@"age":@24};
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
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
