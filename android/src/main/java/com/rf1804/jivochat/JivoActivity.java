package com.rf1804.jivochat;

import android.annotation.TargetApi;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.webkit.WebView;

public class JivoActivity extends AppCompatActivity implements JivoDelegate{
    private Toolbar toolbar;
    private String userName;
    private String userEmail;
    private  String lang = "en";
    private   JivoSdk jivoSdk;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_jivo);
        setToolbar();
        getIntentData();
        setJivoSDK();

    }
    private void setToolbar() {
        toolbar= (Toolbar) findViewById(R.id.toolbar);
        toolbar.setNavigationIcon(R.drawable.ic_back);
        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }
    private void getIntentData(){
      userName= getIntent().getStringExtra("userName");
      userEmail= getIntent().getStringExtra("userEmail");
    }
    private void setJivoSDK(){
     jivoSdk = new JivoSdk((WebView) findViewById(R.id.webView), lang);
      jivoSdk.delegate = this;
      jivoSdk.prepare();
    }
    @Override
    public void onEvent(String name, String data) {
        if(name.equals("url.click")){
            if(data.length() > 2){
                String url = data.substring(1, data.length() - 1);
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                startActivity(browserIntent);
            }
        }
        else if (name.equals("chat.ready")) {
            jivoSdk.callApiMethod("setContactInfo","{\"client_name\": \""+ userName+  "\", \"email\": \"" + userEmail +  "\"}");
        }
    }
}
