package com.example.videotranscoder;

import android.os.Environment;

public class TranscoderThread extends Thread {

	public TranscoderThread() {
		super( "TranscoderThread" );
	}
	
	public void run(){
		String sSDCardDir = Environment.getExternalStorageDirectory().getName();
		
		//String sInAudioFile = sSDCardDir + "/_devtests/in_audio.wav";
		//String sInAudioFile = sSDCardDir + "/_devtests/in_audio_old.wav";
		String sInAudioFile = sSDCardDir + "/_devtests/roh1.mp3";
		
		//String sInVideoFile = sSDCardDir + "/_devtests/in_video.avi";
		//String sInVideoFile = sSDCardDir + "/_devtests/in_video.mp4";
		String sInVideoFile = sSDCardDir + "/_devtests/video02.mp4";
		
		//String sOutVideoFile = sSDCardDir + "/_devtests/out_video.flv";
		String sOutVideoFile = sSDCardDir + "/_devtests/out_video.mp4";

		ffmpeg( new String[] {
				"ffmpeg",
                "-y",
                "-shortest",
                "-i", sInAudioFile,
                "-i", sInVideoFile,
                "-map", "0:0",
                "-map", "1:1",
                "-strict", "experimental",
                "-acodec", "aac",
                "-vcodec", "copy",
                sOutVideoFile
		});
	}

	public native int ffmpeg( String[] args );

	static {
		System.loadLibrary("ffmpeg");
		System.loadLibrary("video-transcoder-jni");
	}
}
