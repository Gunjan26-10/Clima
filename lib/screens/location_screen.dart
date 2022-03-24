import 'dart:convert';
import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({@ required this.weatherData});
  final weatherData;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temp;
  String cityName;
  int id;
  var carryOns;
  var message;

  Future<dynamic> getCityData(String city) async {
    NetworkHelper networkHelper = NetworkHelper(uri: 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=2b3e6e406021851fd2d9ae40e4e6b50e&units=metric');
    var cityData = await networkHelper.getData();
    return cityData;
  }

  @override
  void initState(){
    super.initState();
    updateUI(widget.weatherData);
  }
  void updateUI(dynamic data) {
    setState(() {
      if(data == null){
        temp = 0;
        carryOns = 'Error';
        message = 'Unable to get weather';
        cityName = '';
        return;
      }
      double temperature = data['main']['temp'];
      temp = temperature.toInt();
      id = data['weather'][0]['id'];
      carryOns = weather.getWeatherIcon(id);
      cityName = data['name'];
      message = weather.getMessage(temp);
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () async {
                      var weatherData =  await weather.getLocationData();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      var name = await Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CityScreen();
                         },
                        ),
                      );
                      var cityWeather = await getCityData(name);
                      updateUI(cityWeather);
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$carryOns️',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$message in $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
