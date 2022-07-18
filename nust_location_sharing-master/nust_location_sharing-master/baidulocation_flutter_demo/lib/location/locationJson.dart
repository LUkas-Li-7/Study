import 'package:flutter/cupertino.dart';




class location{
  final List<locationInfo> locationInfos;
  location({required this.locationInfos});
  factory location.fromJson(Map<String, dynamic> parsedJson){
    var list=parsedJson['locationInfos']as List;
    print(list.runtimeType);
    List<locationInfo> locationInfoList =list.map((i) => locationInfo.fromJson(i)).toList();
    return location(
      locationInfos: locationInfoList,
    );
  }
}
class locationInfo{
  final String Pid;
  final String Ip;
  final String Username;
  final double Latitude;
  final double Longitude;
  locationInfo({required this.Pid,required this.Ip,required this.Username,required this.Latitude,required this.Longitude});
  factory locationInfo.fromJson(Map<String, dynamic> parsedJson){
    return locationInfo(
      Pid:parsedJson['Pid'],
      Ip:parsedJson['Ip'],
      Username: parsedJson['Username'],
      Latitude: parsedJson['Latitude'],
      Longitude: parsedJson['Longitude'],
    );
  }
}

class locationMark{
  double? makrLatitude;
  double? markLongitude;
  String? markUsername;
  locationMark(this.markUsername,this.makrLatitude,this.markLongitude);
}
class locationMarkList{
  List<locationMark> locationMarkLists;
  locationMarkList(this.locationMarkLists);
}


