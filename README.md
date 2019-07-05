# chp_app

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

amap_base使用了AndroidX需要修改

关闭AndroidX

implementation 'androidx.appcompat:appcompat:1.0.0-beta01'替换为implementation 'com.android.support:appcompat-v7:27.1.1'

全局搜索AndroidX关键字，像原来的import androidx.core.app.ActivityCompat修改为import android.support.v4.app.ActivityCompat
