/*
终端调试日志的宏定义
 1. 去掉定义DEBUG，可关闭日志
 2. 定义ALogLevel修改日志等级
 
 使用：
 1. 在xxx-Prefix.pch中定义DEBUG和ALogLevel, 并import本文件
 2. 使用示例:
        ALogVerbose(@"msg=%@ number=%d", @"info", 123);
 
 */

// 日志等级常量
#define ALOG_LEVEL_DEBUG     9   // 调试
#define ALOG_LEVEL_INFO      7   // 提示
#define ALOG_LEVEL_WARNING   5   // 警告
#define ALOG_LEVEL_ERROR     3   // 出错

// 日志等级
#ifndef ALogLevel
#define ALogLevel  ALOG_LEVEL_DEBUG   // 初始值
#endif 

// 输出定义
#ifdef DEBUG
#define ALOG_PRINT(xx, yy, ...) NSLog(@"[%@]%s(%d):" xx, yy, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ALOG_PRINT(xx, yy, ...) ((void)0)
#endif

// 调试日志函数
#if ALOG_LEVEL_VERBOSE <= ALogLevel
#define ALogDebug(xx, ...) ALOG_PRINT(xx, @"debug", ##__VA_ARGS__)
#define ALogVerbose(xx, ...) ALOG_PRINT(xx, @"debug", ##__VA_ARGS__)
#else
#define ALogDebug(xx, ...) ((void)0)
#define ALogVerbose(xx, ...) ((void)0)
#endif

// 提示日志函数
#if ALOG_LEVEL_INFO <= ALogLevel
#define ALogInfo(xx, ...) ALOG_PRINT(xx, @"info ", ##__VA_ARGS__)
#else
#define ALogInfo(xx, ...) ((void)0)
#endif

// 警告日志函数
#if ALOG_LEVEL_WARNING <= ALogLevel
#define ALogWarn(xx, ...) ALOG_PRINT(xx, @"warn ", ##__VA_ARGS__)
#else
#define ALogWarn(xx, ...) ((void)0)
#endif

// 出错日志函数
#if ALOG_LEVEL_ERROR <= ALogLevel
#define ALogError(xx, ...) ALOG_PRINT(xx, @"error", ##__VA_ARGS__)
#else
#define ALogError(xx, ...) ((void)0)
#endif



