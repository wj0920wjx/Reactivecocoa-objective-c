//
//  Rac_addObserverViewController.m
//  RACDemo1
//
//  Created by 王杰 on 2018/6/11.
//  Copyright © 2018年 车置宝. All rights reserved.
//

#import "Rac_addObserverViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RACSequenceViewController.h"

@interface Rac_addObserverViewController ()

@property (weak, nonatomic) IBOutlet UIButton *postBtn;

@property (weak, nonatomic) UIView *redView;

@end

@implementation Rac_addObserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalNotice:) name:@"NormalNotice" object:nil];
    @weakify(self);
    //利用RAC实现通知中心的效果 -- NSNotificationCenter
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NormalNotice" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSLog(@"接收到通知");
        //        [self dismissViewControllerAnimated:YES completion:nil];
        CGRect rect = self.postBtn.frame;
        rect.size.height += 5;
        self.postBtn.frame = rect;
    }];
    
    //    [_postBtn addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    //利用RAC实现KVO的效果  -- addObserver
    //方法一：
    
    //        [_redView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
    //            NSLog(@"监听到按钮状态变化");
    //            [self dismissViewControllerAnimated:YES completion:nil];
    //
    //            return nil;
    //        }];
    
//    [[_postBtn rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
//        @strongify(self);
//        NSLog(@"监听到按钮状态变化");
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
    //方法二：
    //    [[_postBtn rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"监听到按钮状态变化");
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //    }];
    //方法三:
    [RACObserve(self.postBtn, frame) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSLog(@"监听到按钮状态变化");
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"sequence" sender:self];
    }];
    
    //时钟事件
    [[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] take:5] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"2秒钟执行一次%@",x);
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
        NSLog(@"5秒后执行");
    }];
    
    [[RACScheduler mainThreadScheduler] after:[self UTCDateFromLocalString:@"2018-06-12 10:54:20"] schedule:^{
        NSLog(@"定一个闹钟在这个时间提醒");
    }];
    
//    [[RACScheduler mainThreadScheduler] after:[self UTCDateFromLocalString:@"2018-06-12 10:58:01"] repeatingEvery:1 withLeeway:0 schedule:^{
//        NSLog(@"从这个时间点开始每隔三秒钟执行一次");
//    }];
    
}

//将当前时间字符串转为UTCDate
-(NSDate *)UTCDateFromLocalString:(NSString *)localString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:localString];
    return date;
}

-(void)normalNotice:(NSNotification *)notice{
    NSLog(@"接收到通知");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postNotice:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalNotice" object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"] && object == _postBtn){
        NSLog(@"监听到按钮状态变化");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NormalNotice" object:nil];
//    [_postBtn removeObserver:self forKeyPath:@"frame"];
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
