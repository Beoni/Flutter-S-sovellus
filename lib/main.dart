
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/weather.dart';
import 'package:charcode/charcode.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
       
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _apiKey = 'c91576f4308e16ed6a832dcd11efbb71';
  //Weather pitää sisällään OpenWeatherMap API:n säätiedot
  Weather _weather;
  WeatherStation _weatherStation;

  String _areaName;

  Image _weatherIcon;

  double _temperature;
  double _tempMax;
  double _tempMin;

  double _windSpeed;
   
  Future weatherFuture;


  @override
  void initState() {
    super.initState();

    _weatherStation = new WeatherStation(_apiKey);
    weatherFuture = _getWeather();
  }

  _getWeather() async{
    return await _weatherStation.currentWeather();
  }

  bool checkIfnull(){
    return [_weather].contains(null);
  }
  
  //Charcode kirjastostra astemerkki
  final String deg = new String.fromCharCode($deg);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather')),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            //Katsotaan että _weather objekti ei ole tyhjä
           
           FutureBuilder(
             future: weatherFuture,
             builder: (context, _weather){
              switch (checkIfnull()) {
                case false:
                  return Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('$_areaName',
                        style: TextStyle(fontSize: 34,color: Colors.pink[300]),),
                        Container(child: _weatherIcon),
                        Text('${_temperature.toStringAsFixed(1)}${deg}C',
                          style: Theme.of(context).textTheme.display1,),
                        Text('${_tempMax.toStringAsFixed(1)}${deg}C - ${_tempMin.toStringAsFixed(1)}${deg}C',
                          style: TextStyle(fontSize: 20,),), 
                        Text('Tuulennopeus: ${_windSpeed.toStringAsFixed(1)} m/s',
                          style: TextStyle(fontSize: 20,),), 
                    ],);
                case true:
                  return Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Paina nappia'),
                      SizedBox(height: 30),
                      Ink(
                        decoration: const ShapeDecoration(shape: CircleBorder(),
                          color: Colors.red,),
                        child: IconButton(icon: Icon(Icons.location_on),iconSize: 40,
                        onPressed: (){
                          _setWeather();
                        },),
                      ),
                    ],);
                    
                default:
                  return Text('Painettu ? nappia');
              }
             }),
            
        ],)
      ),
    );
  }
 
  _setWeather() async{
    _weather = await _weatherStation.currentWeather();
    setState(() {
      _areaName = _weather.areaName;
      _weatherIcon = Image.network('http://openweathermap.org/img/wn/${_weather.weatherIcon}@2x.png');
      _temperature = _weather.temperature.celsius;
      _tempMax = _weather.tempMax.celsius;
      _tempMin = _weather.tempMin.celsius;
      _windSpeed = _weather.windSpeed;
    });
  }
}