//
//  CodeInput.m
//  Runner
//
//  Created by Sayid LS on 2019/1/29.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import "CodeInput.h"

@interface CodeInput ()

@property (nonatomic, strong) UITextField *input;

@end

@implementation CodeInput

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self initUI];
}

- (void)initUI {
    CGRect rc = [[UIScreen mainScreen] bounds];
    
    //返回
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 30, 44)];
    [backButton setImage:[UIImage imageNamed:@"wq_code_scanner_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *backTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 50, 44)];
    [backTitle setText:@"返回"];
    [backTitle setTextColor:[UIColor whiteColor]];
    [backTitle setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:backTitle];
    
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, rc.size.height/2 - 150, rc.size.width, 50)];
    [tip setText:@"请输入充电桩编码"];
    [tip setFont:[UIFont systemFontOfSize:20]];
    [tip setTextColor:[UIColor whiteColor]];
    [tip setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:tip];
    
    _input = [[UITextField alloc] initWithFrame:CGRectMake(40, tip.frame.origin.y + tip.frame.size.height + 30, rc.size.width - 80, 50)];
    [_input setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_input];
    
    UIButton *ok = [[UIButton alloc] initWithFrame:CGRectMake(20, _input.frame.origin.y + _input.frame.size.height + 30, rc.size.width - 40, 50)];
    [ok setBackgroundColor:[UIColor colorWithRed:37/255.0 green:109/255.0 blue:255/255.0 alpha:1/1.0]];
    [ok setTitle:@"前往充电" forState:UIControlStateNormal];
    [ok setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ok addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [ok.layer setMasksToBounds:YES];
    [ok.layer setCornerRadius:5];
    [self.view addSubview:ok];
}

- (void)finish {
    if (_input.text.length > 0) {
        if (self.resultBlock) {
            self.resultBlock(_input.text?:@"");
        }
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)pressBackButton {
    
    UINavigationController *nvc = self.navigationController;
    if (nvc) {
        if (nvc.viewControllers.count == 1) {
            [nvc dismissViewControllerAnimated:YES completion:nil];
        } else {
            [nvc popViewControllerAnimated:NO];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
