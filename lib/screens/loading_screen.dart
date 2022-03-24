import 'package:flutter/material.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

const apikey = '2b3e6e406021851fd2d9ae40e4e6b50e';
class _LoadingScreenState extends State<LoadingScreen> {

  void initState (){
    super.initState();
    getLocation();
  }
  void getLocation() async {
    var weatherData = await WeatherModel().getLocationData();
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return LocationScreen(
        weatherData: weatherData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SpinKitDoubleBounce(
            color: Colors.white,
            size: 50.0,
          ),
      ),
    );
  }
}
