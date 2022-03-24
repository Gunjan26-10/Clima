import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class NetworkHelper {

  NetworkHelper({@required this.uri,  this.latitude,  this.longitude});

  final  uri;
  final  latitude;
  final  longitude;

  Future getData() async {
    http.Response response = await http.get(
        Uri.parse(uri)
    );
    if(response.statusCode == 200){
      var data  = jsonDecode(response.body);
      return data;
    }
  }
}