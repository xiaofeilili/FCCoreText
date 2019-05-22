//
//  ViewController.m
//  FCCoreText
//
//  Created by admin on 2019/5/22.
//  Copyright © 2019 admin. All rights reserved.
//

#import "ViewController.h"
#import "ImgAndTextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor brownColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick {
    ImgAndTextViewController *itvc = [[ImgAndTextViewController alloc] init];
    [self.navigationController pushViewController:itvc animated:YES];
}

@end
