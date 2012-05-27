#ifndef LOGDEFS_H_26MAR2012
#define LOGDEFS_H_26MAR2012

#include <android/log.h>

#include "libavutil/log.h"

#define LOGTAG "VideoTranscoder"

#define LOGV(...) __android_log_print(ANDROID_LOG_VERBOSE, LOGTAG, __VA_ARGS__)
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG  , LOGTAG, __VA_ARGS__)
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO   , LOGTAG, __VA_ARGS__)
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN   , LOGTAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR  , LOGTAG, __VA_ARGS__)

#define vLOGV(fmt, vl) __android_log_vprint(ANDROID_LOG_VERBOSE, LOGTAG, fmt, vl)
#define vLOGD(fmt, vl) __android_log_vprint(ANDROID_LOG_DEBUG  , LOGTAG, fmt, vl)
#define vLOGI(fmt, vl) __android_log_vprint(ANDROID_LOG_INFO   , LOGTAG, fmt, vl)
#define vLOGW(fmt, vl) __android_log_vprint(ANDROID_LOG_WARN   , LOGTAG, fmt, vl)
#define vLOGE(fmt, vl) __android_log_vprint(ANDROID_LOG_ERROR  , LOGTAG, fmt, vl)

#endif
