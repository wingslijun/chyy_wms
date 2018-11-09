package com.chuyiyu.app_v1;


import com.zltd.industry.ScannerManager;

import io.flutter.plugin.common.EventChannel;
import com.chuyiyu.app_v1.SoundUtils;
import java.util.HashMap;
import java.util.Map;

public class ScannerUtils2 implements ScannerManager.IScannerStatusListener {

    EventChannel.EventSink events;
    SoundUtils mSoundUtils;
    int keyCode;
    ScannerManager scannerManager ;

    public ScannerUtils2(EventChannel.EventSink events, SoundUtils mSoundUtils) {
        this.events = events;
        this.mSoundUtils = mSoundUtils;
        scannerManager = ScannerManager.getInstance();
        scannerManager.addScannerStatusListener(this);
    }

    public void singleScanner(int keyCode){
        this.keyCode = keyCode;
        if(!scannerManager.isScanConnect()){
            scannerManager.connectDecoderSRV();
        }
        scannerManager.singleScan();
    }

    @Override
    public void onScannerStatusChanage(int i) {

    }

    @Override
    public void onScannerResultChanage(byte[] bytes) {
        System.out.println("keyCode:"+keyCode);
        System.out.println("data:"+new String(bytes));
        Map result = new HashMap(8);
        result.put(keyCode,new String(bytes));
        events.success(result);
        mSoundUtils.success();
    }
}
