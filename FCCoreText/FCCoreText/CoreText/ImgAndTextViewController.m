//
//  ImgAndTextViewController.m
//  CoreText_Demo
//
//  Created by admin on 2019/5/20.
//  Copyright © 2019 admin. All rights reserved.
//

#import "ImgAndTextViewController.h"
#import "FCDisplayView.h"
#import "FCFrameParser.h"
#import "FCFrameParserConfig.h"
#import "FCCoreTextData.h"

@interface ImgAndTextViewController ()

@end

@implementation ImgAndTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    // 创建画布
    FCDisplayView *displayView = [[FCDisplayView alloc] initWithFrame:self.view.bounds];
    displayView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:displayView];
    
    // 设置配置信息
    FCFrameParserConfig *config = [[FCFrameParserConfig alloc] init];
    config.width = displayView.frame.size.width;
    
    // 获取模板文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testImg" ofType:@"json"];
    FCCoreTextData *data = [FCFrameParser parserTemplateFile:path config:config];
    displayView.data = data;
    displayView.backgroundColor = [UIColor yellowColor];
    
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, data.height);
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
