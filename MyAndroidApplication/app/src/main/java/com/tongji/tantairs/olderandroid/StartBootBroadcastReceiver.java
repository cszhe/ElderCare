package com.tongji.tantairs.olderandroid;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Environment;
import android.util.Log;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 * Created by tantairs on 2015/7/15.
 */
public class StartBootBroadcastReceiver extends BroadcastReceiver {
    private static final String ACTION_BOOT = "android.intent.action.BOOT_COMPLETED";
    private static final String ACTION_SHUTDOWN = "android.intent.action.ACTION_SHUTDOWN";



    public void saveOnOff(String action){
        FileUtil fileUtil = new FileUtil();
        fileUtil.creatSDDir("TrackData1");
        File file = fileUtil.createSDFile("OnOff.txt");

        try {
            FileOutputStream out = new FileOutputStream(file, true);
            out.write(action.getBytes());
            out.write(",".getBytes());
            SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String time = sDateFormat.format(new Date());
            out.write(time.getBytes());
            out.write('\n');
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void onReceive(Context context, Intent intent) {

        // log shutdown and boot event
        this.saveOnOff(intent.getAction());

        // start automatically
        if (intent.getAction().equals(ACTION_BOOT)) {
            Intent service1 = new Intent(context, MyService1.class);
            context.startService(service1);
        }


    }
}
