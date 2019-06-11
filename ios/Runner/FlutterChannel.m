//
//  Flutter.m
//  Runner
//
//  Created by Sayid LS on 2019/1/16.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import "FlutterChannel.h"
#import "RSAEncryptor.h"
#import "WQCodeScanner.h"

@implementation FlutterChannel

+ (void)pushFlutterViewController:(FlutterViewController *)controller; {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"com.che.native" binaryMessenger:controller];
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"callPhone"]) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",call.arguments];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            });
        } else if ([call.method isEqualToString:@"showToast"]) {
            [self showMessage:[NSString stringWithFormat:@"%@", call.arguments] duration:3];
        } else if([call.method isEqualToString:@"getSystemVersion"]) {
            result([[UIDevice currentDevice] systemVersion]);
        } else if ([call.method isEqualToString:@"scanf"]) {
            WQCodeScanner *scanner = [[WQCodeScanner alloc] init];
            [controller presentViewController:scanner animated:YES completion:nil];
            scanner.resultBlock = ^(NSString *value) {
                result(value);
            };
        } else if([call.method isEqualToString:@"encrypt"]) {
            NSDictionary * argsMap = (NSDictionary *)call.arguments;
            NSString * text = (NSString *)argsMap[@"txt"];
            NSString * publicKey = (NSString *)argsMap[@"publicKey"];
            result([RSAEncryptor encryptString:text publicKey:publicKey]);
        }
    }];
}

#pragma mark  提示条
+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)time
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor grayColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(207, 999)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    
    label.frame = CGRectMake(10, 5, labelSize.width +20, labelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    
    showview.frame = CGRectMake((screenSize.width - labelSize.width - 20)/2,
                                screenSize.height - labelSize.height - 30,
                                labelSize.width+40,
                                labelSize.height+10);
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end
