#include <android/log.h>
#include <jni.h>

#include <stdlib.h>
#include <pthread.h>

#include "logdefs.h"

static pthread_key_t key;
static pthread_once_t key_once = PTHREAD_ONCE_INIT;

int main( int argc, char** argv );

void log_callback_help(void* ptr, int level, const char* fmt, va_list vl)
{
	switch(level)
	{
	case AV_LOG_QUIET:
		return;
	case AV_LOG_PANIC:
	case AV_LOG_FATAL:
	case AV_LOG_ERROR:
		vLOGE( fmt, vl );
		break;
	case AV_LOG_WARNING:
		vLOGW( fmt, vl );
		break;
	case AV_LOG_INFO:
		vLOGI( fmt, vl );
		break;
	case AV_LOG_VERBOSE:
		vLOGV( fmt, vl );
		break;
	case AV_LOG_DEBUG:
	default:
		vLOGD( fmt, vl );
		break;
	}
}

static JavaVM* g_pVM;

JNIEXPORT
jint
JNICALL
JNI_OnLoad(JavaVM* pJVM, void* reserved)
{
	LOGI( "Loading native library compiled at " __TIME__ " " __DATE__ );

	g_pVM = pJVM;
	av_log_set_callback( log_callback_help );
	
	LOGD( "g_pVM=0x%x",g_pVM );

	return JNI_VERSION_1_2;
}

struct Args
{
	int argc;
	char** argv;
};

void* worker_thread_run( void* _args )
{
	struct Args* args = (struct Args*)_args;
	LOGD( "Calling main()" );

	int ret = main( args->argc, args->argv );
	
	LOGI("main() finished");
	pthread_exit(&ret);
}

int ffmpeg( JNIEnv* env, jobject this, jobjectArray args )
{
	//handle and initiante ffmpeg's main arguments
	int i = 0;
	int argc = 0;
	char **argv = NULL;

	if( args != NULL )
	{
		argc = (*env)->GetArrayLength(env, args);
		argv = (char **) malloc(sizeof(char *) * argc);

		for( i=0; i<argc; i++ )
		{
			jstring str = (jstring)(*env)->GetObjectArrayElement(env, args, i);
			argv[i] = (char *)(*env)->GetStringUTFChars(env, str, NULL);
		}
	}

	struct Args _args = {argc, argv};
	pthread_t worker_thread;

	LOGD("Starting worker thread");
	int ret = pthread_create( &worker_thread, NULL, worker_thread_run, (void*)&_args );
	if( ret )
	{
		LOGE( "Error starting worker thread: %d", ret);
		return ret;
	}

	LOGD("Worker thread started");

	int* pret;
	pthread_join( worker_thread, (void**)&pret);
	LOGD("Worker thread finished: %d", *pret);

	return *pret;
}

JNIEXPORT
int
JNICALL
Java_com_lancelotmobile_ane_ffmpeg_FFmpegFunction_ffmpeg( JNIEnv* env, jobject this, jobjectArray args )
{
	return ffmpeg( env, this, args );
}

JNIEXPORT
int
JNICALL
Java_com_example_videotranscoder_VideoTranscoder_ffmpeg( JNIEnv* env, jobject this, jobjectArray args )
{
	return ffmpeg( env, this, args );
}

JNIEXPORT
int
JNICALL
Java_com_example_videotranscoder_TranscoderThread_ffmpeg( JNIEnv* env, jobject this, jobjectArray args )
{
	return ffmpeg( env, this, args );
}

