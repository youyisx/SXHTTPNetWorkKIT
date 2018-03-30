//
//  JRBaseAPI.h
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

FOUNDATION_EXTERN NSString * const JRAPIHTTPMethod_GET;
FOUNDATION_EXTERN NSString * const JRAPIHTTPMethod_POST;

@class AFHTTPSessionManager,JRCommonCookie;
@interface JRBaseAPI : NSObject


@property (nonatomic, copy) NSString * httpMethod;//默认为 JRAPIHTTPMethod_POST

@property (nonatomic,strong)JRCommonCookie * commonCookies;//默认cookies

/** request 超时时间设置 */
@property (nonatomic) NSTimeInterval timeoutInterval;


/** 以下函数 子类均可根据需求进行重载 */

- (AFHTTPSessionManager *)httpSessionManager;

- (RACSignal *)request:(NSDictionary *)param;


/** API PATH */
- (NSString *)path;

/** API Request 相关固定参数 */
- (NSDictionary *)commonParam;

/** cookie 追加的cookie */
- (NSDictionary *)cookie;

/** header 追加的header */
- (NSDictionary *)headerField;

/** 发入请求前，最后一次调整参数的机会 */
- (NSDictionary *)adjustTotalParam:(NSDictionary *)param;

@end
