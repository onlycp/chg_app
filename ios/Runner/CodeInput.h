//
//  CodeInput.h
//  Runner
//
//  Created by Sayid LS on 2019/1/29.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CodeInput : UIViewController

@property (nonatomic, copy) void(^resultBlock)(NSString *value);


@end

NS_ASSUME_NONNULL_END
