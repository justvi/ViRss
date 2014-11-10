//
//  ArticleViewController.m
//  ViRss
//
//  Created by lhs on 14/10/28.
//  Copyright (c) 2014年 lhs. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *content = [[UIWebView alloc] initWithFrame:CGRectMake(40, 80, 600, 600)];
    [content loadHTMLString:self.contentString baseURL:nil];
    [self.view addSubview:content];
    self.view.backgroundColor = [UIColor whiteColor];
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
