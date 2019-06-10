//
//  WQCodeScanner.h
//  CodeScanner
//
//  Created by wangyuxiang on 2017/3/27.
//  Copyright © 2017年 wangyuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQCodeScanner : UIViewController

@property (nonatomic, copy) void(^resultBlock)(NSString *value);

@end
