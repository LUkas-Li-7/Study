import 'dart:ui';

import 'package:baidulocation_flutter_demo/location/locationJson.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'locationShare.dart';

///默认加载显示的首页面
class sharePage extends StatefulWidget {
  const sharePage({Key? key}) : super(key: key);

  @override
  State<sharePage> createState() => _sharePage();
}

class User {
  String RoomId;
  String Username;
  User(this.RoomId,this.Username);
}
class _sharePage extends State<sharePage> {
  ///房间名使用
  late final TextEditingController _nameController = TextEditingController();
  ///密码使用
  late final TextEditingController _passwordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            //第一层 背景图片
            buildFunction1(),
            //第二层 高斯模糊
            buildFunction2(),
            //第三层 登录输入层
            buildFunction3(),
          ],
        ),
      ),
    );
  }

  buildFunction1() {
    return Positioned.fill(
      child: Image.asset(
        "resources/share.png",
        fit: BoxFit.fill,
      ),
    );
  }

  buildFunction2() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          color: Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }

  buildFunction3() {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "请输入房间号",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(33)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: "请输入名字",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(33)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 300,
            height: 48,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(33)),
              child: ElevatedButton(
                onPressed: () {
                  String rId = _nameController.text;
                  String username = _passwordController.text;
                  final  user =User(rId, username);

                  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => locationSharePage(),
                      settings: RouteSettings(
                        arguments: user,
                      ),
                    ),
                  );

                },
                child: const Text("开始"),
              ),
            ),
          )
        ],
      ),
    );
  }

}
