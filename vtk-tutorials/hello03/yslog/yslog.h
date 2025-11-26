#ifndef YS_LOG_H_
#define YS_LOG_H_

/*
 * yslog is thread-safe
 */

#include <string.h>

#ifdef _WIN32
#define YS_DIR_SEPARATOR '\\'
#define YS_DIR_SEPARATOR_STR "\\"
#else
#define YS_DIR_SEPARATOR '/'
#define YS_DIR_SEPARATOR_STR "/"
#endif

#ifndef __FILENAME__
// #define __FILENAME__  (strrchr(__FILE__, DIR_SEPARATOR) ? strrchr(__FILE__, DIR_SEPARATOR) + 1 : __FILE__)
#define __FILENAME__ (strrchr(YS_DIR_SEPARATOR_STR __FILE__, YS_DIR_SEPARATOR) + 1)
#endif

#ifdef __cplusplus
extern "C"
{
#endif

#define YS_EXPORT __attribute__((visibility("default")))

#define YS_CLR_CLR "\033[0m"      /* 恢复颜色 */
#define YS_CLR_BLACK "\033[30m"   /* 黑色字 */
#define YS_CLR_RED "\033[31m"     /* 红色字 */
#define YS_CLR_GREEN "\033[32m"   /* 绿色字 */
#define YS_CLR_YELLOW "\033[33m"  /* 黄色字 */
#define YS_CLR_BLUE "\033[34m"    /* 蓝色字 */
#define YS_CLR_PURPLE "\033[35m"  /* 紫色字 */
#define YS_CLR_SKYBLUE "\033[36m" /* 天蓝字 */
#define YS_CLR_WHITE "\033[37m"   /* 白色字 */

#define YS_CLR_BLK_WHT "\033[40;37m"     /* 黑底白字 */
#define YS_CLR_RED_WHT "\033[41;37m"     /* 红底白字 */
#define YS_CLR_GREEN_WHT "\033[42;37m"   /* 绿底白字 */
#define YS_CLR_YELLOW_WHT "\033[43;37m"  /* 黄底白字 */
#define YS_CLR_BLUE_WHT "\033[44;37m"    /* 蓝底白字 */
#define YS_CLR_PURPLE_WHT "\033[45;37m"  /* 紫底白字 */
#define YS_CLR_SKYBLUE_WHT "\033[46;37m" /* 天蓝底白字 */
#define YS_CLR_WHT_BLK "\033[47;30m"     /* 白底黑字 */

// XXX(id, str, clr)
#define YS_LOG_LEVEL_MAP(XXX)                      \
    XXX(YS_LOG_LEVEL_DEBUG, "DEBUG", YS_CLR_WHITE) \
    XXX(YS_LOG_LEVEL_INFO, "INFO ", YS_CLR_GREEN)  \
    XXX(YS_LOG_LEVEL_WARN, "WARN ", YS_CLR_YELLOW) \
    XXX(YS_LOG_LEVEL_ERROR, "ERROR", YS_CLR_RED)   \
    XXX(YS_LOG_LEVEL_FATAL, "FATAL", YS_CLR_RED_WHT)

    typedef enum
    {
        YS_LOG_LEVEL_VERBOSE = 0,
#define XXX(id, str, clr) id,
        YS_LOG_LEVEL_MAP(XXX)
#undef XXX
            YS_LOG_LEVEL_SILENT
    } ys_log_level_e;

#define YS_DEFAULT_LOG_FILE "yshttpserver"
#define YS_DEFAULT_LOG_LEVEL YS_LOG_LEVEL_INFO
#define YS_DEFAULT_LOG_FORMAT "%y-%m-%d %H:%M:%S.%z %L %s"
#define YS_DEFAULT_LOG_REMAIN_DAYS 1
#define YS_DEFAULT_LOG_MAX_BUFSIZE (1 << 14)  // 16k
#define YS_DEFAULT_LOG_MAX_FILESIZE (1 << 24) // 16M

    // logger: default file_logger
    // network_logger() see event/nlog.h
    typedef void (*ys_logger_handler)(int loglevel, const char *buf, int len);

    YS_EXPORT void ys_stdout_logger(int loglevel, const char *buf, int len);
    YS_EXPORT void ys_stderr_logger(int loglevel, const char *buf, int len);
    YS_EXPORT void ys_file_logger(int loglevel, const char *buf, int len);
    // network_logger implement see event/nlog.h
    // YS_EXPORT void ys_network_logger(int loglevel, const char* buf, int len);

    typedef struct ys_logger_s ys_logger_t;
    YS_EXPORT ys_logger_t *ys_logger_create();
    YS_EXPORT void ys_logger_destroy(ys_logger_t *logger);

    YS_EXPORT void ys_logger_set_handler(ys_logger_t *logger, ys_logger_handler fn);
    YS_EXPORT void ys_logger_set_level(ys_logger_t *logger, int level);
    // level = [VERBOSE,DEBUG,INFO,WARN,ERROR,FATAL,SILENT]
    YS_EXPORT void ys_logger_set_level_by_str(ys_logger_t *logger, const char *level);
    /*
     * format  = "%y-%m-%d %H:%M:%S.%z %L %s"
     * message = "2020-01-02 03:04:05.067 DEBUG message"
     * %y year
     * %m month
     * %d day
     * %H hour
     * %M min
     * %S sec
     * %z ms
     * %Z us
     * %l First character of level
     * %L All characters of level
     * %s message
     * %% %
     */
    YS_EXPORT void ys_logger_set_format(ys_logger_t *logger, const char *format);
    YS_EXPORT void ys_logger_set_max_bufsize(ys_logger_t *logger, unsigned int bufsize);
    YS_EXPORT void ys_logger_enable_color(ys_logger_t *logger, int on);
    YS_EXPORT int ys_logger_print(ys_logger_t *logger, int level, const char *fmt, ...);

    // below for file logger
    YS_EXPORT void ys_logger_set_file(ys_logger_t *logger, const char *filepath);
    YS_EXPORT void ys_logger_set_max_filesize(ys_logger_t *logger, unsigned long long filesize);
    // 16, 16M, 16MB
    YS_EXPORT void ys_logger_set_max_filesize_by_str(ys_logger_t *logger, const char *filesize);
    YS_EXPORT void ys_logger_set_remain_days(ys_logger_t *logger, int days);
    YS_EXPORT void ys_logger_enable_fsync(ys_logger_t *logger, int on);
    YS_EXPORT void ys_logger_fsync(ys_logger_t *logger);
    YS_EXPORT const char *ys_logger_get_cur_file(ys_logger_t *logger);

    // yslog: default logger instance
    YS_EXPORT ys_logger_t *ys_default_logger();
    YS_EXPORT void ys_destroy_default_logger(void);

// macro yslog*
#define yslog ys_default_logger()
#define yslog_destory() ys_destroy_default_logger()
#define yslog_disable() ys_logger_set_level(yslog, LOG_LEVEL_SILENT)
#define yslog_set_file(filepath) ys_logger_set_file(yslog, filepath)
#define yslog_set_level(level) ys_logger_set_level(yslog, level)
#define yslog_set_level_by_str(level) ys_logger_set_level_by_str(yslog, level)
#define yslog_set_handler(fn) ys_logger_set_handler(yslog, fn)
#define yslog_set_format(format) ys_logger_set_format(yslog, format)
#define yslog_set_max_filesize(filesize) ys_logger_set_max_filesize(yslog, filesize)
#define yslog_set_max_filesize_by_str(filesize) ys_logger_set_max_filesize_by_str(yslog, filesize)
#define yslog_set_remain_days(days) ys_logger_set_remain_days(yslog, days)
#define yslog_enable_fsync() ys_logger_enable_fsync(yslog, 1)
#define yslog_disable_fsync() ys_logger_enable_fsync(yslog, 0)
#define yslog_fsync() ys_logger_fsync(yslog)
#define yslog_get_cur_file() ys_logger_get_cur_file(yslog)

#define yslogd(fmt, ...) ys_logger_print(yslog, YS_LOG_LEVEL_DEBUG, fmt " [%s:%d:%s]", ##__VA_ARGS__, __FILENAME__, __LINE__, __FUNCTION__)
#define yslogi(fmt, ...) ys_logger_print(yslog, YS_LOG_LEVEL_INFO, fmt " [%s:%d:%s]", ##__VA_ARGS__, __FILENAME__, __LINE__, __FUNCTION__)
#define yslogw(fmt, ...) ys_logger_print(yslog, YS_LOG_LEVEL_WARN, fmt " [%s:%d:%s]", ##__VA_ARGS__, __FILENAME__, __LINE__, __FUNCTION__)
#define ysloge(fmt, ...) ys_logger_print(yslog, YS_LOG_LEVEL_ERROR, fmt " [%s:%d:%s]", ##__VA_ARGS__, __FILENAME__, __LINE__, __FUNCTION__)
#define yslogf(fmt, ...) ys_logger_print(yslog, YS_LOG_LEVEL_FATAL, fmt " [%s:%d:%s]", ##__VA_ARGS__, __FILENAME__, __LINE__, __FUNCTION__)

// below for android
#if defined(ANDROID) || defined(__ANDROID__)
#include <android/log.h>
#define LOG_TAG "JNI"
#undef yslogd
#undef yslogi
#undef yslogw
#undef ysloge
#undef yslogf
#define yslogd(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)
#define yslogi(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define yslogw(...) __android_log_print(ANDROID_LOG_WARN, LOG_TAG, __VA_ARGS__)
#define ysloge(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define yslogf(...) __android_log_print(ANDROID_LOG_FATAL, LOG_TAG, __VA_ARGS__)
#endif

// macro alias
#if !defined(LOGD) && !defined(LOGI) && !defined(LOGW) && !defined(LOGE) && !defined(LOGF)
#define LOGD yslogd
#define LOGI yslogi
#define LOGW yslogw
#define LOGE ysloge
#define LOGF yslogf
#endif

#ifdef __cplusplus
} // extern "C"
#endif

#endif // YS_LOG_H_
