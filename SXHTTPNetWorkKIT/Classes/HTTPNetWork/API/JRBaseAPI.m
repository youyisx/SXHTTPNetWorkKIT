//
//  JRBaseAPI.m
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//


NSString * const JRAPIHTTPMethod_GET = @"GET";
NSString * const JRAPIHTTPMethod_POST = @"POST";

#import "JRBaseAPI.h"
#import "JRHTTPSessionManager.h"
#import "JRHTTPRequestSerializer.h"
#import "JRJSONResponseserializer.h"
#import "JRHTTPDefine.h"
#import "JRCommonCookie.h"
@interface JRBaseAPI()

@property (nonatomic, strong) AFHTTPSessionManager * sessionManager;

@end

@implementation JRBaseAPI
@dynamic timeoutInterval;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [self httpSessionManager];
        _commonCookies = [JRCommonCookie commonCookieWithDomain:@".jumei.com"];
        _httpMethod = JRAPIHTTPMethod_POST;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
#pragma mark --- get && set
-(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval{
    self.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

-(NSTimeInterval)timeoutInterval{
    return self.sessionManager.requestSerializer.timeoutInterval;
}
#pragma mark --- request 之前的准备工作

-(AFHTTPSessionManager *)httpSessionManager{
    AFHTTPSessionManager * sessionManager_ = [[JRHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:JRBASEURL_DEV]];
    sessionManager_.requestSerializer = [JRHTTPRequestSerializer serializer];
    sessionManager_.responseSerializer = [JRJSONResponseserializer serializer];

    return sessionManager_;
}

- (void)requestConfig{
    
    NSDictionary * headerField_ = [self headerField];
    for (NSString * key in headerField_.allKeys) {
        [self.sessionManager.requestSerializer setValue:[headerField_[key] description] forHTTPHeaderField:key];
    }
    NSString * cookieStr_ = nil;
    NSDictionary * cookies = [self cookie];
    if (self.commonCookies&&[self.commonCookies isKindOfClass:[JRCommonCookie class]]) {
         [self.commonCookies appendCookies:cookies];
        cookieStr_ = self.commonCookies.cookies;
    }else{
        cookieStr_ = [JRCommonCookie cookiesWithParam:cookies];
    }
   
    if (cookieStr_.length > 0) {
        [self.sessionManager.requestSerializer setValue:cookieStr_ forHTTPHeaderField:@"Cookie"];
    }
}



#pragma mark --- send request

- (NSURLSessionDataTask *)postRequest:(NSDictionary *)param_
                           subscriber:(id<RACSubscriber>) subscriber{
    NSURLSessionDataTask * sessionTask =
    [self.sessionManager POST:[self path]
                   parameters:param_
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          [subscriber sendNext:responseObject];
                          [subscriber sendCompleted];
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          [subscriber sendError:error];
                      }];
    return sessionTask;
}

- (NSURLSessionDataTask *)getRequest:(NSDictionary *)param_
                          subscriber:(id<RACSubscriber>) subscriber{
    NSURLSessionDataTask * sessionTask =
    [self.sessionManager GET:[self path]
                  parameters:param_
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         [subscriber sendNext:responseObject];
                         [subscriber sendCompleted];
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         [subscriber sendError:error];
                     }];
    return sessionTask;
}

- (RACSignal *)request:(NSDictionary *)param{
    return [[self requestCommand] execute:param];
}

- (RACCommand *)requestCommand{
//    @weakify(self)
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *param_) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            @strongify(self)
            [self requestConfig];

            NSMutableDictionary * totalParam_ = [self commonParam].mutableCopy;
            [totalParam_ addEntriesFromDictionary:param_];
            NSDictionary * lastParam_ = [self adjustTotalParam:totalParam_];
            NSURLSessionDataTask * task = nil;
            if ([self.httpMethod isEqualToString:JRAPIHTTPMethod_POST]) {
                task = [self postRequest:lastParam_ subscriber:subscriber];
            }else if ([self.httpMethod isEqualToString:JRAPIHTTPMethod_GET]){
                task = [self getRequest:lastParam_ subscriber:subscriber];
            }
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    }];;
}

#pragma mark --- extend param

/** 以下函数 字类可根据需求进行重载 */

/** API PATH */
- (NSString *)path{
    return @"";
}

/** API Request 相关json参数 */
- (NSDictionary *)commonParam{
    return @{};
}

/** cookie 追加参数 */
- (NSDictionary *)cookie{
    return @{};
}

/** header 追加参数 */
- (NSDictionary *)headerField{
    return @{};
}

/** 发入请求前，最后一次调整参数的机会 */
- (NSDictionary *)adjustTotalParam:(NSDictionary *)param{
    return param;
}

@end
