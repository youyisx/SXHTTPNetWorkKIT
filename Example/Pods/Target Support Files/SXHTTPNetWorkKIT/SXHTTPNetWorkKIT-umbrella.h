#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JRBaseAPI.h"
#import "JRHTTPRequestSerializer.h"
#import "JRHTTPSessionManager.h"
#import "JRJSONResponseserializer.h"
#import "JRCommonCookie.h"
#import "JRHelper.h"
#import "JRHTTPDefine.h"
#import "JRHTTPError.h"

FOUNDATION_EXPORT double SXHTTPNetWorkKITVersionNumber;
FOUNDATION_EXPORT const unsigned char SXHTTPNetWorkKITVersionString[];

