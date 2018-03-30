//
//  JRHTTPSessionManager.m
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "JRHTTPSessionManager.h"

@implementation JRHTTPSessionManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //https 不检验证书
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;

    }
    return self;
}
@end
