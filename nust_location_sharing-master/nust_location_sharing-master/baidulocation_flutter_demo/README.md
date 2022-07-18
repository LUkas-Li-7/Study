# baidulocation_flutter_demo

A new Flutter project.

## Getting Started
所需的环境：flutter 2.10.4
           dart：2.16.2
使用的编译器：Android Studio
申请百度Android定位SDK的AK：https://lbsyun.baidu.com/index.php?title=android-locsdk/guide/create-project/key
添加AK的位置：https://lbsyun.baidu.com/index.php?title=android-locsdk/guide/create-project/android-studio

项目部署之后再pubspec.yaml中下载依赖.

项目使用过程中需要注意的地方：
1.在输入房间号和名字的页面时使用完小键盘之后手动将小键盘关闭再点击开始，不然有概率报错.
2.点击开始进入共享界面后请耐心等待一段时间后就会出现，如果两个用户的定位位置相隔较远请手动放缩地图即可看到两个用户的定位位置.
3.在本地运行服务器代码后要查看本机的ip地址将locationShare.dart中的两个url，var uri = Uri.http('1.15.23.231:15553', '/get')中的1.15.23.231改成本机ip.

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
