#!/bin/bash

NDK=~/dev/android/android-ndk-r7b_;
PLATFORM=$NDK/platforms/android-8/arch-arm/;
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86;

CODECS=""

# mov
CODECS="${CODECS} --enable-muxer=mov --enable-demuxer=mov"
# rawvideo
CODECS="${CODECS} --enable-decoder=rawvideo --enable-encoder=rawvideo --enable-muxer=rawvideo --enable-demuxer=rawvideo"
# mjpeg
CODECS="${CODECS} --enable-parser=mjpeg --enable-decoder=mjpeg --enable-encoder=mjpeg --enable-muxer=mjpeg --enable-demuxer=mjpeg"
# h263
CODECS="${CODECS} --enable-parser=h263 --enable-decoder=h263 --enable-encoder=h263 --enable-muxer=h263 --enable-demuxer=h263"
# mpeg
CODECS="${CODECS} --enable-parser=mpegaudio --enable-parser=mpegvideo"
# mpeg4
CODECS="${CODECS} --enable-parser=mpeg4audio --enable-decoder=mpeg4 --enable-encoder=mpeg4 --enable-demuxer=mpeg4  --enable-muxer=mp4"
# h264
CODECS="${CODECS} --enable-parser=h264 --enable-decoder=h264 --enable-encoder=libx264 --enable-muxer=h264 --enable-demuxer=h264"
# flv
CODECS="${CODECS} --enable-decoder=flv --enable-encoder=flv --enable-muxer=flv --enable-demuxer=flv"
# mp3
CODECS="${CODECS} --enable-decoder=mp3 --enable-encoder=libmp3lame --enable-muxer=mp3 --enable-demuxer=mp3"
# swf
CODECS="${CODECS} --enable-decoder=adpcm_swf --enable-encoder=adpcm_swf --enable-muxer=swf --enable-demuxer=swf"
# aac
CODECS="${CODECS} --enable-parser=aac --enable-decoder=aac --enable-encoder=aac --enable-demuxer=aac"
# wav
CODECS="${CODECS} --enable-decoder=adpcm_ima_wav --enable-encoder=adpcm_ima_wav --enable-muxer=wav --enable-demuxer=wav"
# pcm_s16le
CODECS="${CODECS} --enable-decoder=pcm_s16le --enable-encoder=pcm_s16le --enable-muxer=pcm_s16le --enable-demuxer=pcm_s16le --enable-parser=pcm_s16le"
# ffv1
CODECS="${CODECS} --enable-decoder=ffv1 --enable-encoder=ffv1"
# other
#CODECS="${CODEC} --enable-demuxer=image2 --enable-decoder=rawvideo"

#CODECS="${CODECS} --enable-parser= --enable-decoder= --enable-encoder= --enable-muxer= --enable-demuxer="

function build_one
{
	./configure \
		--target-os=linux \
		--prefix=$PREFIX \
		--enable-cross-compile \
		--extra-libs="-lgcc" \
		--arch=arm \
		--cc=$PREBUILT/bin/arm-linux-androideabi-gcc \
		--cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
		--nm=$PREBUILT/bin/arm-linux-androideabi-nm \
		--sysroot=$PLATFORM \
		--extra-cflags=" -O3 -fpic -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS -Ilibmp3lame -Ilibx264 -Ilibfaac " \
		--extra-cxxflags=" -D__STDC_CONSTANT_MACROS " \
		--disable-shared \
		--enable-static \
		--extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog -Llibmp3lame -Llibx264 -Llibfaac " \
		--disable-ffplay \
		--enable-avformat \
		--enable-avcodec \
		--enable-swscale \
		--enable-version3 \
		--enable-gpl \
		--enable-memalign-hack \
		--enable-avfilter \
		--enable-avdevice \
		--enable-libmp3lame \
		--enable-libx264 \
        --enable-libfaac \
		--enable-nonfree \
		--enable-zlib \
		--disable-network \
		--disable-everything \
		--enable-protocol=file \
		$CODECS \
		$ADDITIONAL_CONFIGURE_FLAG;
	make clean;
	make -j4 install;
	$PREBUILT/bin/arm-linux-androideabi-ar d libavcodec/libavcodec.a inverse.o;
	$PREBUILT/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -soname libffmpeg.so -shared -nostdlib  -z,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a libswresample/libswresample.a libpostproc/libpostproc.a libmp3lame/libmp3lame.a libx264/libx264.a libfaac/libfaac.a libavfilter/libavfilter.a libavdevice/libavdevice.a -lc -lm -lz -ldl -llog  --warn-once  --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/arm-linux-androideabi/4.4.3/libgcc.a;
};

#arm v7vfpv3
#CPU=armv7-a
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=$CPU "
#PREFIX=./android/$CPU
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

#arm v7vfp
#CPU=armv7-a
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
#PREFIX=./android/$CPU-vfp
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

#arm v7n
#CPU=armv7-a
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"
#PREFIX=./android/$CPU-neon
#ADDITIONAL_CONFIGURE_FLAG=--enable-neon
#build_one

#arm v7-a
CPU=armv7-a
OPTIMIZE_CFLAGS="-marm -march=$CPU"
PREFIX=./android/$CPU
ADDITIONAL_CONFIGURE_FLAG=
build_one

#arm v6+vfp
#CPU=armv6
#OPTIMIZE_CFLAGS="-DCMP_HAVE_VFP -mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU"
#PREFIX=./android/${CPU}_vfp
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

#arm v6
#CPU=armv6
#OPTIMIZE_CFLAGS="-marm -march=$CPU"
#PREFIX=./android/${CPU}
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

##arm v5+vfp
#CPU=armv5
#OPTIMIZE_CFLAGS="-DCMP_HAVE_VFP -mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU"
#PREFIX=./android/${CPU}_vfp
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

##arm v5te
#CPU=armv5te
#OPTIMIZE_CFLAGS="-marm -march=$CPU"
#PREFIX=./android/${CPU}
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

