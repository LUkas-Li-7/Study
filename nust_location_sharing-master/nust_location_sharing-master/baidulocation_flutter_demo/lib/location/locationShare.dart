import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:baidulocation_flutter_demo/widgets/loc_appbar.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:idkit_ip/idkit_ip.dart';
import 'dart:io';
import 'share.dart';
import 'package:baidulocation_flutter_demo/main.dart';
import 'package:flutter/services.dart';
import 'locationJson.dart';


class ResBody {

  double? latitude;
  double? longitude;
  ResBody(this.latitude, this.longitude);

}
var list=[];
String? ip;
String? deviceName;
String? deviceVersion;
String? identifier;
String? roomId;
String? username;
int time=0;
int? timeTwo;


class locationSharePage extends StatefulWidget  {

  const locationSharePage({Key? key}) : super(key:key);
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<locationSharePage> {
  BaiduLocation _loationResult = BaiduLocation();
  late BMFMapController _myMapController;
  late locationMarkList locationmarkList;
  late location locations;
  final LocationFlutterPlugin _myLocPlugin = LocationFlutterPlugin();
  bool _suc = false;
  @override
  void initState() {
    super.initState();
    timeTwo=0;
    //接受定位回调
    _myLocPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
      setState(() {
        _loationResult = result;
        _locationFinish();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stopLocation();
  }

  Future<void>_deviceDetails() async{
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model!;
          deviceVersion = build.version.toString();
          identifier = build.androidId!;
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = data.name!;
          deviceVersion = data.systemVersion!;
          identifier = data.identifierForVendor!;
        });//UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

  }

  Future<void> handleRequests(HttpServer server) async {
    await for (HttpRequest request in server) {
      //   {"latitude" : _loationResult.getMap()["latitude"],
      // "longitude": _loationResult.getMap()["longitude"],}
      request.response.write({"latitude" : _loationResult.getMap()["latitude"],
        "longitude": _loationResult.getMap()["longitude"],});
      await request.response.close();
    }
  }

  Future<void> serverMain() async {
    final server = await createServer();
    print('Server started: ${server.address} port ${server.port}');
    await handleRequests(server);
  }

  Future<HttpServer> createServer() async {
    /**
     * 114 X21
     * 79 X21A
     * 97 P40PRO
     */
    final address = InternetAddress.tryParse(ip!);
    const port = 40401;
    return await HttpServer.bind(address, port);
  }

  @override
  Widget build(BuildContext context) {
    User? user = ModalRoute.of(context)!.settings.arguments as User?;
    roomId=user?.RoomId! as String;
    username=user?.Username! as String;
    print(user?.Username);
    print("传来的user数据");
    List<Widget> resultWidgets = [];
    if (_loationResult.callbackTime != null) {
      _loationResult.getMap().forEach((key, value) {
        //resultWidgets.add(_resultWidget(key, value));
      });
    }

    return MaterialApp(
        home: Scaffold(
          appBar: BMFAppBar(
            title: '位置共享',
            isBack: true,
            onBack: () {
              Navigator.pop(context);
            },
          ),
          body: Column(children: [

            _createMapContainer(),
            Container(height: 30),
            SizedBox(
              height: MediaQuery.of(context).size.height - 750,
              child: ListView(
                children: resultWidgets,
              ),
            ),

            _createButtonContainer()
          ]),
        ));
  }

  Widget _createMapContainer() {
    return SizedBox(
        height: 570,
        child: BMFMapWidget(
          onBMFMapCreated: (controller) {
            _onBMFMapCreated(controller);
          },
          mapOptions: _initMapOptions(),
        ));
  }

  Container _createButtonContainer() {
    if(timeTwo==0){
      _locationAction();
      //serverMain();
      getIp();
      _deviceDetails();
      if(time==1){
        get();}
    _startLocation();}

    /*if(time==1){
      Future.delayed(Duration(seconds: 1), (){
        Navigator.of(context).pop();
        print('延时1s执行');
      });
      time=0;
    }*/

    return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
           /*ElevatedButton(
                onPressed: () {

                },
                child: const Text('开始定位'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent, //change background color of button
                  onPrimary: Colors.yellow, //change text color of button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                )),
            Container(width: 60),*/
            ElevatedButton(
                onPressed: () {
                  _stopLocation();
                  time=0;
                  timeTwo=1;
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Home()));
                },
                child: const Text('退出共享'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent, //change background color of button
                  onPrimary: Colors.yellow, //change text color of button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ))
          ],
        ));
  }

  //回调定位信息输出
  // Widget _resultWidget(key, value) {
  //   return Center(
  //     child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text('$key:' ' $value'),
  //         ]),
  //   );
  // }

  void getIp()async{
    ip = await IDKitIp.getIPv4();
    print(ip);
  }
  void _locationAction() async {
    /// 设置android端和ios端定位参数
    /// android 端设置定位参数
    /// ios 端设置定位参数
    Map iosMap = _initIOSOptions().getMap();
    Map androidMap = _initAndroidOptions().getMap();

    _suc = await _myLocPlugin.prepareLoc(androidMap, iosMap);
    print('设置定位参数：$iosMap');
  }

  /// 设置地图参数
  BaiduLocationAndroidOption _initAndroidOptions() {
    BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
        coorType: 'bd09ll',
        locationMode: BMFLocationMode.hightAccuracy,
        isNeedAddress: true,
        isNeedAltitude: true,
        isNeedLocationPoiList: true,
        isNeedNewVersionRgc: true,
        isNeedLocationDescribe: true,
        openGps: true,
        scanspan: 4000,
        coordType: BMFLocationCoordType.bd09ll);
    return options;
  }

  BaiduLocationIOSOption _initIOSOptions() {
    BaiduLocationIOSOption options = BaiduLocationIOSOption(
        coordType: BMFLocationCoordType.bd09ll,
        BMKLocationCoordinateType: 'BMKLocationCoordinateTypeBMK09LL',
        desiredAccuracy: BMFDesiredAccuracy.best,
        allowsBackgroundLocationUpdates: true,
        pausesLocationUpdatesAutomatically: false);
    return options;
  }

  // /// 启动定位
  Future<void> _startLocation() async {
    _suc = await _myLocPlugin.startLocation();
    print('开始连续定位：$_suc');

    print("time"+time.toString());

  }

  //请求对方数据
  get() async {
    //X21A get1
    final client1=http.Client();
    // var uri = Uri.http('1.15.23.231:15553', '/get');
    var uri = Uri.http('123.5.215.12', '/get');
    //var uri = Uri.http('192.168.101.111:15553', '/get');
    print("jsaon1111111111111111111111111111111111111111111111111111111111111");
    print(json.encode({"ip" :ip,"latitude" : _loationResult.getMap()["latitude"].toString(),
      "pid":identifier,"rid":roomId,"longitude": _loationResult.getMap()["longitude"].toString(),"state":1}));
    await client1.post(uri, headers: {"content-type": "application/json"}, body: json.encode({"ip" :ip,"username":username,"latitude" : _loationResult.getMap()["latitude"],
      "pid":identifier,"rid":roomId,"longitude": _loationResult.getMap()["longitude"],"state":1}))
        .then((response) {
      print("post方式->status: ${response.statusCode}");
      print("post方式->body: ${response.body}");
      String jsonProduct = response.body;
      final jsonResponse = json.decode(jsonProduct);
      locations = new location.fromJson(jsonResponse);
      print("-------------------------");
      print(_loationResult.getMap()["latitude"].toString());
      print(_loationResult.getMap()["longitude"].toString());
      client1.close();
    });
    //_loationResultResponse = responseBody;//获取到的数据
  }

  /// 停止定位(开始共享)
  void _stopLocation() async {
    //_loationResultResponse = responseBody;//获取到的数据
    _suc = await _myLocPlugin.stopLocation();
    final client=http.Client();
    print('停止连续定位：$_suc');


    try{
       // var uri = Uri.http('1.15.23.231:15553', '/get');
       var uri = Uri.http('123.5.215.12', '/get');
      //var uri = Uri.http('192.168.101.111:15553', '/get');
      await client.post(uri, headers: {"content-type": "application/json"}, body: json.encode({"ip" :ip,"username":username,"latitude" : _loationResult.getMap()["latitude"],
      "pid":identifier,"rid":roomId,"longitude": _loationResult.getMap()["longitude"],"state":0}))
        .then((response) {
      print("post方式->status: ${response.statusCode}");
      print("post方式->body: ${response.body}");
    });}
   finally{
      print("aaaaaaaaaaaaaaaa");
    client.close();
};
  }

  ///定位完成添加mark
  void _locationFinish() {
    list.forEach((element) {
      _myMapController.removeOverlay(element);
    });
    list.clear();
    /// 添加Marker
    _myMapController.cleanAllMarkers();
    locations.locationInfos.forEach((item) {
      locationMark locationmark=locationMark(item.Username, item.Latitude,item.Longitude);
      /// 创建BMFMarker
      BMFMarker marker1 = BMFMarker(
          position: BMFCoordinate(locationmark.makrLatitude ?? 0.0, locationmark.markLongitude ?? 0.0),
          title: 'flutterMaker',
          identifier: 'flutter_marker',
          icon: 'resources/icon_mark.png');
      print(_loationResult.latitude.toString() + _loationResult.longitude.toString());
      _myMapController.addMarker(marker1);
      /// text经纬度信息
      BMFCoordinate position = new BMFCoordinate(locationmark.makrLatitude ?? 0.0, locationmark.markLongitude ?? 0.0);
      /// 构造text
      BMFText bmfText = BMFText(
          text: item.Username,
          position: position,
          bgColor: Colors.transparent,
          fontColor: Colors.black,
          fontSize: 40,
          typeFace: BMFTypeFace( familyName: BMFFamilyName.sMonospace,
              textStype: BMFTextStyle.BOLD_ITALIC),
          alignY: BMFVerticalAlign.ALIGN_TOP,
          alignX: BMFHorizontalAlign.ALIGN_LEFT,
          rotate: 0.0);
      /// 添加text
      list.add(bmfText.Id);
      _myMapController.addText(bmfText);

    });
    ///设置中心点
    _myMapController.setCenterCoordinate(
        BMFCoordinate(_loationResult.latitude ?? 0.0, _loationResult.longitude ?? 0.0), false);
  }

  /// 设置地图参数
  BMFMapOptions _initMapOptions() {
    BMFMapOptions mapOptions = BMFMapOptions(
        center: BMFCoordinate(39.917215, 116.380341),
        zoomLevel: 19, //越大缩放等级越高
        mapPadding: BMFEdgeInsets(top: 0, left: 0, right: 0, bottom: 0));
    return mapOptions;
  }
void setTimeTwo(int timeTwo){
    timeTwo=0;
}
  /// 创建完成回调
  void _onBMFMapCreated(BMFMapController controller) {
    _myMapController = controller;
    /// 地图加载回调
    _myMapController.setMapDidLoadCallback(callback: () {
      timeTwo=0;
      time=1;
      print('mapDidLoad-地图加载完成');
    });
  }
}
