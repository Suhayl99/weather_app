import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:weather_app/hive_utils.dart';

import '../weather_model.dart';

class WeatherService with HiveUtil {
  static Future<WatherModel> getWeatherInfo(String value) async{
         String date = '';
  WatherModel? weatherModel = WatherModel();
        List<String> todayList = [];
        List<String> weekDays = [];
        List<String> days = [];
        List<String> tempDay = [];
        List<String> tempNight = [];
        List<String> feeling = [];
        List<String> rainPerc = [];
        var response = await get(Uri.parse('https://pogoda.uz/$value'));
        if (response.statusCode == 200) {
          var document = parse(response.body);
          String haroratKun = document.getElementsByTagName("strong")[0].text;
          //print(haroratKun);
          String haroratTun = document
              .getElementsByClassName("current-forecast")[0]
              .getElementsByTagName('span')[2]
              .text;
          //print(haroratTun);
          String obhavo =
              document.getElementsByClassName('current-forecast-desc')[0].text;
          //print(obhavo);
          String today = document.getElementsByClassName('current-day')[0].text;
          //print(today);
          String city = document.getElementsByTagName("h2")[0].text;
          //print(city);
          String weekName = document.getElementsByTagName("h3")[0].text;
          //print(weekName);
          //kun haqida malumot
          todayList.add(weekName); //hafta 0
          todayList.add(city); //shahar  1
          todayList.add(today); // 2
          todayList.add(haroratKun); //3
          todayList.add(haroratTun); //4
          todayList.add(obhavo); //5
          var tasnif = document
              .getElementsByClassName("current-forecast-details")[0]
              .querySelectorAll('p');
          tasnif.forEach((element) {
            todayList.add(element.text);
          });
          //hafta nomi
          var weekNames = document
              .getElementsByTagName('table')[0]
              .getElementsByTagName('strong');
          for (int i = 0; i < weekNames.length; i++) {
            if (i.isOdd) {
              weekDays.add(weekNames[i].text);
            }
          }
          weekDays.remove(weekNames[0].text);
          // //kunlar
          var dayNames = document
              .getElementsByTagName('table')[0]
              .getElementsByTagName('div');
          for (int i = 1; i < dayNames.length; i++) {
            if (i.isOdd) {
              days.add(dayNames[i].text);
            }
          }
          days.remove(dayNames[0].text);
          var tempDays = document
              .getElementsByTagName('table')[0]
              .getElementsByClassName('forecast-day');
          for (int i = 0; i < tempDays.length; i++) {
            tempDay.add(tempDays[i].text);
          }

          var tempNights = document
              .getElementsByTagName('table')[0]
              .getElementsByClassName('forecast-night');
          for (int i = 0; i < tempNights.length; i++) {
            tempNight.add(tempNights[i].text);
          }

          var feelings = document
              .getElementsByTagName('table')[0]
              .getElementsByClassName('weather-row-desc');
          for (int i = 0; i < feelings.length; i++) {
            feeling.add(feelings[i].text);
          }
          feeling.remove(feelings[0].text);

          var rainPercs = document
              .getElementsByTagName('tbody')[0]
              .getElementsByClassName('weather-row-pop');
          for (int i = 1; i < rainPercs.length; i++) {
            rainPerc.add(rainPercs[i].text);
          }
          date =
              "${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}";
          weatherModel = WatherModel(
              date: date,
              feeling: feeling,
              rainPerc: rainPerc,
              today: todayList,
              tempDay: tempDay,
              tempNight: tempNight,
              days: days,
              weekDays: weekDays);


  }
          return weatherModel;
  }
}
