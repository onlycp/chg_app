package cn.xuwuo.app.chpapp;

import android.Manifest;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.FileProvider;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.jarvan.fluwx.utils.FileUtil;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.FileCallback;
import com.lzy.okgo.model.Response;

import java.io.File;
import java.security.KeyFactory;

import javax.crypto.Cipher;

import cn.xuwuo.app.chpapp.util.Constant;
import cn.xuwuo.app.chpapp.zxing.activity.CaptureActivity;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;

public class MainActivity extends FlutterActivity {

  private int WRITE_EXTERNAL_STORAGE_CODE = 110;

  public MethodChannel.Result result;

  private String url;

  private int permissionCode;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), "com.che.native").setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result mResult) {
        result = mResult;
        switch (methodCall.method) {
          case "callPhone":
            callPhone(methodCall.arguments.toString());
            break;
          case "showToast":
            showToast(methodCall.arguments.toString());
            break;
          case "tabBarColor":
            tabBarColor();
            break;
          case "scanf":
            scanf();
            break;
          case "getVersion":
            getVersion();
            break;
          case "encrypt":
            encrypt(methodCall);
            break;
          case "downloadApp":
            url = (String) methodCall.argument("url");
            downloadApp();
            break;
          case "permission":
            permissionCode = (int)methodCall.argument("permissionCode");
            permission((String) methodCall.argument("permission"));
            break;
        }
      }
    });
  }

  private void downloadApp() {
    int hasWriteStoragePermission = ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE);
    if (hasWriteStoragePermission != PackageManager.PERMISSION_GRANTED) {
      //没有权限，向用户请求权限
      ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, WRITE_EXTERNAL_STORAGE_CODE);
    }else {
      down();
    }
  }

  private void down() {
    Toast.makeText(MainActivity.this, "文件下载中！", Toast.LENGTH_LONG).show();
    OkGo.<File>get(url).tag(this).execute(new FileCallback(Environment.getExternalStorageDirectory().getAbsolutePath() + "//che/", "chp.apk") {
      @Override
      public void onSuccess(Response<File> response) {
        installApk(MainActivity.this, Environment.getExternalStorageDirectory().getAbsolutePath() + "//che/chp.apk");
      }

      @Override
      public void onError(Response<File> response) {
        super.onError(response);
        Toast.makeText(MainActivity.this, "文件下载失败！", Toast.LENGTH_LONG).show();
      }
    });
  }

  //安装apk
  void installApk(Context context, String pathName) {
    File apkfile = new File(pathName);
    if (!apkfile.exists()) {
      return;
    }
    Uri uri;
    Intent intent = new Intent(Intent.ACTION_VIEW);
    if (Build.VERSION.SDK_INT >= 24) {
      uri = FileProvider.getUriForFile(context, "cn.xuwuo.app.chpapp.fileprovider", new File(apkfile.toString()));
      intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
    } else {
      uri = Uri.parse("file://" + apkfile.toString());
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    }
    intent.setDataAndType(uri, "application/vnd.android.package-archive");
    startActivity(intent);
  }

  private void permission(String permission) {
    int hasWriteStoragePermission = ContextCompat.checkSelfPermission(this, permission);
    if (hasWriteStoragePermission != PackageManager.PERMISSION_GRANTED) {
      //没有权限，向用户请求权限
      ActivityCompat.requestPermissions(this, new String[]{permission}, permissionCode);
    }else {
      result.success(true);
    }
  }

  private void callPhone(String number) {
    Intent intent = new Intent(Intent.ACTION_DIAL);
    intent.setData(Uri.parse("tel:" + number));
    startActivity(intent);
  }

  private void showToast(String content) {
    Toast.makeText(this, content, Toast.LENGTH_LONG).show();
  }

  private void tabBarColor() {
    if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.LOLLIPOP) {
      getWindow().setStatusBarColor(0);
      getWindow().getDecorView().setSystemUiVisibility( View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
    }
  }

  private void scanf() {
    if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
      if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.CAMERA)) {
        Toast.makeText(this, "请至权限中心打开本应用的相机访问权限", Toast.LENGTH_LONG).show();
      }
      // 申请权限
      ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, Constant.REQ_PERM_CAMERA);
      return;
    }
    // 二维码扫码
    Intent intent = new Intent(MainActivity.this, CaptureActivity.class);
    startActivityForResult(intent, Constant.REQ_QR_CODE);
  }

  private void getVersion() {
    try {
      result.success(getPackageManager().getPackageInfo(getPackageName(), 0).versionCode);
    } catch (Exception e) {
      result.error("获取版本信息失败", null, null);
    }
  }

  private void encrypt(MethodCall call) {
    String text = call.argument("txt");
    String publicKey = call.argument("publicKey");
    if (text != null && publicKey != null) {
      try {
        String encoded = encryptData(text, publicKey);
        result.success(encoded);
      } catch (Exception e) {
        e.printStackTrace();
        result.error("UNAVAILABLE", "Encrypt failure.", null);
      }
    }else{
      result.error("NULL INPUT STRING", "Encrypt failure.", null);
    }
  }

  private String encryptData(String txt, String publicKey) {
    String encoded = "";
    byte[] encrypted;
    try {
      byte[] publicBytes = Base64.decode(publicKey, Base64.DEFAULT);
      X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicBytes);
      KeyFactory keyFactory = KeyFactory.getInstance("RSA");
      PublicKey pubKey = keyFactory.generatePublic(keySpec);
      Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1PADDING");
      cipher.init(Cipher.ENCRYPT_MODE, pubKey);
      encrypted = cipher.doFinal(txt.getBytes());
      encoded = Base64.encodeToString(encrypted, Base64.DEFAULT);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return encoded;
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    //扫描结果回调
    if (requestCode == Constant.REQ_QR_CODE && resultCode == RESULT_OK) {
      String scanResult = data.getExtras().getString(Constant.INTENT_EXTRA_KEY_QR_SCAN);
      if(scanResult == null) {
        result.error("没有扫描出结果", null, null);
      } else {
        result.success(scanResult);
      }
    }
  }

  @Override
  public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    //通过requestCode来识别是否同一个请求
    if (requestCode == WRITE_EXTERNAL_STORAGE_CODE){
      if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED){
        down();
      }else{
        Toast.makeText(this, "申请失败", Toast.LENGTH_LONG).show();
      }
    }else if (requestCode == permissionCode){
      if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED){
        result.success(true);
      }else{
        result.success(false);
      }
    }
  }

}
