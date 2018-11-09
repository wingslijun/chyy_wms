package com.chuyiyu.app_v1;

import android.os.Bundle;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;

import com.chuyiyu.app_v1.ScannerUtils2;
import com.chuyiyu.app_v1.SoundUtils;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  //EventChannel.EventSink event1;
  SoundUtils mSoundUtils;
    ScannerUtils2 s;
  public static final String STREAM = "chyy_scanner_plugin.barcode";


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
      mSoundUtils = SoundUtils.getInstance();
      mSoundUtils.init(this);

    new EventChannel(getFlutterView(), STREAM).setStreamHandler(
            new EventChannel.StreamHandler() {
              @Override
              public void onListen(Object args, final EventChannel.EventSink events) {
               // event1=events;
                s = new ScannerUtils2(events, mSoundUtils);
              }
              @Override
              public void onCancel(Object args) {
                Log.w("c", "cancelling listener");
              }
            }
    );
  }


  @Override
  public boolean onKeyDown(int keyCode, KeyEvent event) {
    if((keyCode == 524 || keyCode == 526)&& event.getRepeatCount()==0 ){
        if(s!=null ){
            s.singleScanner(keyCode);
        }
    }
    return super.onKeyDown(keyCode, event);
  }

}
