//
//  JRHTTPError.h
//  JRWallet
//
//  Created by jumei_vince on 2018/3/30.
//  Copyright © 2018年 vince_. All rights reserved.
//

#ifndef JRHTTPError_h
#define JRHTTPError_h


enum {
    JRJSONErrorUnkonw = -900000L,
    JRJSONErrorError = -900001L,
    JRJSONErrorResultError = -900002L,
    JRJSONErrorDataTypeNotMatch = -900010L,
    JRJSONErrorForbidden = -900403L
};

 NSString *const JRJSONErrorDomain = @"com.jr.jsonError";


#endif /* JRHTTPError_h */
