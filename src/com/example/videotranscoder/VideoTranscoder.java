/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.example.videotranscoder;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class VideoTranscoder extends Activity
{
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) 
	{
		super.onCreate(savedInstanceState);
	
		TextView  tv = new TextView(this);
		tv.setText( "Starting" );
		setContentView(tv);
		
		Thread worker = new TranscoderThread();
		worker.start();
		
		tv.setText( "Working" );
		
		try {
			worker.join();
			tv.setText( "Finished" );
		} catch (InterruptedException e) {
			tv.setText( "Transcoding failed. Reason:" + e.getMessage() );
		}
	}
}
