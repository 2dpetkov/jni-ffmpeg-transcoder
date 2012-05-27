LOCAL_PATH := $(call my-dir)

FFMPEG_DIR := ffmpeg-0.10.2
FFMPEG_PATH := $(LOCAL_PATH)/$(FFMPEG_DIR)

#FFMPEG_ANDROID_ARCH := armv7-a
#FFMPEG_ANDROID_ARCH := armv7-a-vfp
#FFMPEG_ANDROID_ARCH := armv6_vfp
FFMPEG_ANDROID_ARCH := armv6
#FFMPEG_ANDROID_ARCH := armv5_vfp
#FFMPEG_ANDROID_ARCH := armv5te
FFMPEG_ANDROID_DIR := $(FFMPEG_DIR)/android/$(FFMPEG_ANDROID_ARCH)
FFMPEG_ANDROID_PATH := $(LOCAL_PATH)/$(FFMPEG_ANDROID_DIR)

FFMPEG_LIBS := $(addprefix, $(FFMPEG_ANDROID_DIR)/lib, \
	libavdevice/libavdevice.a \
	libavformat/libavformat.a \
	libavcodec/libavcodec.a \
	libavfilter/libavfilter.a \
	libswscale/libswscale.a \
	libavutil/libavutil.a \
	libpostproc/libpostproc.a \
	libmp3lame/libmp3lame.a \
	libx264/libx264.a \
    libfaac/libfaac.a )

include $(CLEAR_VARS)
LOCAL_MODULE := video-transcoder-jni
# ffmpeg uses its own deprecated functions liberally, so turn off that annoying noise
LOCAL_CFLAGS += -g
LOCAL_CPPFLAGS += -D__STDC_CONSTANT_MACROS
LOCAL_C_INCLUDES := $(FFMPEG_ANDROID_PATH)/include $(FFMPEG_PATH)
LOCAL_LDLIBS += -llog -lz -lm $(FFMPEG_ANDROID_PATH)/libffmpeg.so $(FFMPEG_LIBS)
LOCAL_SHARED_LIBRARY := ffmpeg-prebuilt
LOCAL_SRC_FILES := video-transcoder-jni.c ffmpeg.c cmdutils.c
include $(BUILD_SHARED_LIBRARY)

#include $(CLEAR_VARS)
#LOCAL_MODULE  := ffmpeg
#LOCAL_CFLAGS += -g -Wno-deprecated-declarations
#LOCAL_C_INCLUDES := $(FFMPEG_ANDROID_PATH)/include $(FFMPEG_PATH)
#LOCAL_LDLIBS += -llog -lz -lm $(FFMPEG_ANDROID_PATH)/libffmpeg.so $(FFMPEG_LIBS)
#LOCAL_SRC_FILES := $(FFMPEG_DIR)/ffmpeg.c $(FFMPEG_DIR)/cmdutils.c
#include $(BUILD_EXECUTABLE)


#declare the prebuilt library
include $(CLEAR_VARS)
LOCAL_MODULE := ffmpeg-prebuilt
LOCAL_SRC_FILES := $(FFMPEG_ANDROID_DIR)/libffmpeg.so
LOCAL_EXPORT_C_INCLUDES := $(FFMPEG_ANDROID_DIR)/include
LOCAL_EXPORT_LDLIBS := $(FFMPEG_ANDROID_DIR)/libffmpeg.so
LOCAL_PRELINK_MODULE := true
include $(PREBUILT_SHARED_LIBRARY)

##the andzop library
#include $(CLEAR_VARS)
#LOCAL_ALLOW_UNDEFINED_SYMBOLS=false
#LOCAL_MODULE := video-transcoder-jni
#LOCAL_SRC_FILES := video-transcoder-jni.c $(FFMPEG_DIR)/ffmpeg.c $(FFMPEG_DIR)/cmdutils.c
#LOCAL_C_INCLUDES := $(FFMPEG_ANDROID_PATH)/include $(FFMPEG_PATH)
#LOCAL_SHARED_LIBRARY := ffmpeg-prebuilt
#LOCAL_LDLIBS := -llog -ljnigraphics -lz -lm $(FFMPEG_ANDROID_PATH)/libffmpeg.so $(FFMPEG_LIBS)
#include $(BUILD_SHARED_LIBRARY)

