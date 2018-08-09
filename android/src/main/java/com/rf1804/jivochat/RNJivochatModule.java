
package com.rf1804.jivochat;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.webkit.WebView;

import java.util.Locale;

import com.rf1804.jivochat.R;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

class RNJivochatModule extends ReactContextBaseJavaModule {

  public RNJivochatModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName() {
    return "RNJivochat";
  }

  @ReactMethod
  public void openJivoChat(String userName, String userEmail) {
    ReactApplicationContext context = getReactApplicationContext();
    Intent intent = new Intent(context, JivoActivity.class);
    intent.putExtra("userName",userName);
    intent.putExtra("userEmail",userEmail);
    context.startActivity(intent);
  }
}
