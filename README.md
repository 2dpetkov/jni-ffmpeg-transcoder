jni-ffmpeg-transcoder
=====================
* Build ffmpeg for Android:
** go to ./jni/ffmpeg-0.10.2
** edit build_ffmpeg_android.sh so that the NDK var points to the correct NDK directory
** run ./build_ffmpeg_android.sh - all result .so files go to ./android/<arm_v>

* Build Transcoder JNI bindings:
** edit build_jni_lib.sh so that NDK_DIR points to the correct NDK directory
** run ./build_ffmpeg_android.sh or ./build_ffmpeg_android.sh clean or ./build_ffmpeg_android.sh clean all - all result libs go to ./libs

