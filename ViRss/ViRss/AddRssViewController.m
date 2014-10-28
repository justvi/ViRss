//
//  AddRssViewController.m
//  ViRss
//
//  Created by lhs on 14/10/28.
//  Copyright (c) 2014年 lhs. All rights reserved.
//

#import "AddRssViewController.h"

@interface AddRssViewController ()

@end

@implementation AddRssViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 120, 300, 40)];
    [self.textInput setBorderStyle:UITextBorderStyleRoundedRect];
    self.textInput.delegate = self;
    [self.view addSubview:self.textInput];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textInput resignFirstResponder];
    NSLog(@"%@", self.textInput.text);
    return YES;
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
