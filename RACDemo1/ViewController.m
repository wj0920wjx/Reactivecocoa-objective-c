//
//  ViewController.m
//  RACDemo1
//
//  Created by 王杰 on 2018/6/11.
//  Copyright © 2018年 车置宝. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *racBtn;

@property (weak, nonatomic) IBOutlet UITextField *racTextField1;
@property (weak, nonatomic) IBOutlet UITextField *racTextField2;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 按钮的信号处理
    [self RACBtnAction];
    
    // 输入框的信号处理
    [self RACTextFieldAction];
}

#pragma mark -- 按钮的信号处理
//正常按钮的监听事件
- (IBAction)btnClick:(UIButton *)sender {//UIControlEventTouchUpInside
    NSLog(@"按钮被点击");
}

//使用RAC实现按钮事件的监听--内聚、简短
//RAC使用@weakify(self);和@strongify(self);来避免block循环引用
-(void)RACBtnAction
{
    @weakify(self);
//    RACSignal *signal = [self.racBtn rac_signalForControlEvents:UIControlEventTouchUpInside];
    //RACSignal -- 信号
//    [[self.racBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        NSLog(@"UIControlEventTouchUpInside -- RAC监听方式");
//    }];
    
    //如果我需要在点击按钮的时候让按钮不可再次点击？
//    [[[self.racBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
//        self.racBtn.enabled = NO;
//    }] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        NSLog(@"UIControlEventTouchUpInside -- RAC监听方式");
//    }];
    
    //通常情况下 我们需要点击按钮之后去请求网络或者加载等待，有结果之后再做处理---异步处理的方式？
    [[[[self.racBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.racBtn.enabled = NO;
    }] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
        @strongify(self);
        return [self requestForSignal];
    }] subscribeNext:^(NSNumber *success) {
        @strongify(self);
        NSLog(@"UIControlEventTouchUpInside -- RAC监听方式%@",success);
        if ([success boolValue]) {
            self.racBtn.enabled = YES;
        }
    }];
}

-(RACSignal *)requestForSignal{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        sleep(3);
//        [subscriber sendError:nil];
        [subscriber sendNext:@(1)];
        [subscriber sendCompleted];
        return nil;
    }];
}

#pragma mark -- RACTextFieldAction 输入框的信号处理
-(void)RACTextFieldAction{
    @weakify(self);
    //输入框一般会出现的限制条件 -- 通过代理实现对输入框字符变化的监听或者开始/结束状态的监听
//    [[_racTextField1 rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"%@",x);
//    }];
//
    //字符长度限制 >3
//    [[[_racTextField1 rac_textSignal] filter:^BOOL(NSString * _Nullable value) {
//        return value.length >3;
//    }] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    //字符长度
//    [[[[_racTextField1 rac_textSignal] map:^id _Nullable(NSString * _Nullable value) {//映射
//        return @([value length]);
//    }] filter:^BOOL(id  _Nullable value) {
//        return [value integerValue] > 3;
//    }] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    //改变颜色
    [[[[_racTextField1 rac_textSignal] map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 3);
    }] map:^id _Nullable(NSNumber *success) {
        return [success boolValue]?[UIColor redColor]:[UIColor clearColor];
    }] subscribeNext:^(UIColor *color) {
        @strongify(self);
        self.racTextField1.backgroundColor = color;
    }];
    
    // =====
    RACSignal *userNameSign = [[_racTextField1 rac_textSignal] map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 3);
    }];
    RAC(self.racTextField1,backgroundColor) = [userNameSign map:^id _Nullable(NSNumber *success) {
        return [success boolValue]?[UIColor redColor]:[UIColor clearColor];
    }];
    
    RACSignal *passwordSign = [[_racTextField2 rac_textSignal] map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 3);
    }];
    RAC(self.racTextField2,backgroundColor) = [passwordSign map:^id _Nullable(NSNumber *success) {
        return [success boolValue]?[UIColor redColor]:[UIColor clearColor];
    }];
    
    //联合两个信号进行一个事件处理
    RACSignal *combineSignal = [RACSignal combineLatest:@[userNameSign,passwordSign] reduce:^id (NSNumber*usernameValid, NSNumber *passwordValid){
        return @([usernameValid boolValue]&&[passwordValid boolValue]);
    }];
    [combineSignal subscribeNext:^(NSNumber *enabled) {
        @strongify(self);
        self.loginBtn.enabled = [enabled boolValue];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
