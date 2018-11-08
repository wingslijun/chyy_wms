package com.chuyiyu.app_v1;


import com.zltd.industry.ScannerManager;

import io.flutter.plugin.common.EventChannel;
import com.chuyiyu.app_v1.SoundUtils;

public class ScannerUtils2 implements ScannerManager.IScannerStatusListener {

    EventChannel.EventSink events;
    SoundUtils mSoundUtils;
    public ScannerUtils2(EventChannel.EventSink events, SoundUtils mSoundUtils) {
        this.events = events;
        this.mSoundUtils = mSoundUtils;
    }

    public void singleScanner(){
        ScannerManager scannerManager =  ScannerManager.getInstance();
        scannerManager.connectDecoderSRV();
        scannerManager.addScannerStatusListener(this);
        scannerManager.singleScan();

    }

    @Override
    public void onScannerStatusChanage(int i) {

    }

    @Override
    public void onScannerResultChanage(byte[] bytes) {
        System.out.println("data:"+new String(bytes));

        events.success( new String(bytes));
        mSoundUtils.success();
    }
}
