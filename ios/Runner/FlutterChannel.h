//
//  Flutter.h
//  Runner
//
//  Created by Sayid LS on 2019/1/16.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterChannel : UICollectionView

+ (void)pushFlutterViewController:(FlutterViewController *)controller;

@end

NS_ASSUME_NONNULL_END
