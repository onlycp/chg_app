//
//  RSAEncryptor.h
//  Runner
//
//  Created by Sayid LS on 2019/1/21.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSAEncryptor : NSObject

+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

@end

NS_ASSUME_NONNULL_END
