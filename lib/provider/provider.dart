import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';

import '../models/weather_model.dart';


class WeatherProvider extends ChangeNotifier{
 
  WeatherProvider(){
    getWeather(cityNameWeather);
  }

  WatherModel weatherModel = WatherModel();
  String cityNameWeather = "tashkent";
  final List<String> cityName = [
    "tashkent",
    "andijon",
    "bukhara",
    "gulistan",
    "jizzakh",
    "zarafshan",
    "karshi",
    "navoi",
    "namangan",
    "nukus",
    "samarkand",
    "termez",
    "urgench",
    "ferghana",
    "khiva"
  ];
  String? value = "tashkent";

  List<bool> listCheked = [true, false, false, false, false, false, false];
  

  
  getWeather(String item) async{
    WeatherService.getWeatherInfo(cityNameWeather).then((value){
      weatherModel = value;
      notifyListeners();
    });    

}
  

  getListChecked(int number){
    listCheked = [false, false, false, false, false, false, false];
    listCheked[number]=true;
    notifyListeners();
  }

  getValue(String item){
    value = item;
    cityNameWeather = item.toLowerCase();
  }


String weatherIcon(String position) {
  if (position.trim().contains('Ясно')) {
    return 'assets/ic_sunny.png';
  } else if (position.trim().contains('пасмурно') ||
      position.trim().contains('переменная облачность')) {
    return 'assets/ic_mist.png';
  } else if (position.trim().contains("небольшой дождь")) {
    return 'assets/ic_drizzle.png';
  } else if (position.trim().contains("молния")) {
    return 'assets/ic_storm.png';
  } else if (position.trim().contains("снег")) {
    return 'assets/ic_snow.png';
  }
  return 'assets/ic_cloudy.png';
}
}