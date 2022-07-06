import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constans.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:weather_app/hive_utils.dart';
import 'package:weather_app/weather_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<WatherModel>(WatherModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HiveUtil {
  final Color textColor1 = const Color(0xff25272E);
  final Color textColor2 = const Color.fromRGBO(203, 203, 203, 1);
  WatherModel? weatherModel = WatherModel();
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
  String? _value = "tashkent";

  List<bool> listCheked = [true, false, false, false, false, false, false];

  Future<bool?>? _loadData(String country) async {
    if (await loadLocalData()) {
      try {
        String date = '';
        List<String> todayList = [];
        List<String> weekDays = [];
        List<String> days = [];
        List<String> tempDay = [];
        List<String> tempNight = [];
        List<String> feeling = [];
        List<String> rainPerc = [];
        var response = await get(Uri.parse('https://pogoda.uz/$country'));
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

          await saveBox<String>(dateBox, date);
          await saveBox<WatherModel>(weatherBox, weatherModel!);

          return true;
        } else {
          _showMessage('Unknown error');
        }
      } on SocketException {
        _showMessage('Connection error');
      } catch (e) {
        _showMessage(e.toString());
      }
    }
    return null;
  }

  Future<bool> loadLocalData() async {
    try {
      var date = await getBox<String>(dateBox, key: dateKey);
      if (date ==
          DateFormat('dd.MM.yyyy')
              .format(DateTime.now().add(const Duration(days: -1)))) {
        weatherModel =
            (await getBox<WatherModel>(weatherBox, key: weatherModelKey) ?? [])
                as WatherModel?;
        return false;
      } else {
        return true;
      }
    } catch (e) {
      log(e.toString());
    }

    return true;
  }

  _showMessage(String text, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green[400],
        content: Text(
          text,
          style: kTextStyle(size: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: scaffoldWeatherGradient,
        ),
        child: SafeArea(
          child: FutureBuilder(
              future:  _loadData(_value!),
              builder: (context, AsyncSnapshot snapshot) {
                if ( snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                height: 50,
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xff9A60E5)
                                          .withOpacity(0.16),
                                      blurRadius: 30,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/settings.png',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Image(
                                      image:
                                          AssetImage('assets/ic_location.png'),
                                      width: 15,
                                      height: 17.48,
                                    ),
                                    const SizedBox(width: 7.5),
                                    DropdownButton<String>(
                                      value: _value,
                                      items: cityName
                                          .map(
                                            (e) => DropdownMenuItem<String>(
                                              value: e,
                                              child: Text(
                                                e,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (item) {
                                        setState(() {
                                          _value = item;
                                          cityNameWeather = item!.toLowerCase();
                                          _loadData(_value!);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    gradient: containerWeatherGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Updating°',
                                    style: kTextStyle(size: 12),
                                  ),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                height: 50,
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  image: const DecorationImage(
                                      image: AssetImage('assets/user.png'),
                                      fit: BoxFit.cover),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xff9A60E5)
                                          .withOpacity(0.16),
                                      blurRadius: 30,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shrinkWrap: true,
                          children: [
                            WaetherMainBox(
                              image: _weatherIcon(weatherModel!.today![5]),
                              today: weatherModel!.today![2],
                              day: weatherModel!.today![3],
                              night: weatherModel!.today![4],
                              obhavo: weatherModel!.today![5],
                            ),
                            WeatherInfoBox(
                              pressed:
                                  "${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}",
                              textColor1: textColor1,
                              textColor2: textColor2,
                              pess: weatherModel!.today![6].split(':').first,
                              pessSum: weatherModel!.today![6].split(':').last,
                              wind: weatherModel!.today![7].split(':').first,
                              windSum: weatherModel!.today![7].split(':').last,
                              sun: weatherModel!.today![8].split(':').first,
                              sunSum: weatherModel!.today![8].split(':').last,
                              moon: weatherModel!.today![9].split(':').first,
                              moonSum: weatherModel!.today![9].split(':').last,
                              rain: weatherModel!.today![10].split(':').first,
                              rainSum: weatherModel!.today![10].split(':').last,
                              sunset: weatherModel!.today![6].split(':').first,
                              sunsetSum:
                                  weatherModel!.today![6].split(':').last,
                            ),
                            Text(
                              weatherModel!.today![0],
                              style: kTextStyle(
                                  color: textColor1,
                                  fontWeight: FontWeight.bold,
                                  size: 22),
                            ),
                            SizedBox(
                              height: 250,
                              child: Flexible(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 25),
                                  shrinkWrap: true,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          listCheked.clear();
                                          listCheked = [
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false
                                          ];
                                          listCheked[0] = true;
                                        });
                                      },
                                      child: WeeklyItem(
                                        isActive: listCheked[0],
                                        textColor1: textColor1,
                                        textColor2: textColor2,
                                        weekName: weatherModel!.weekDays![0],
                                        weekDay: weatherModel!.days![0],
                                        temp: weatherModel!.tempDay![0],
                                        rain: weatherModel!.rainPerc![0],
                                        image: _weatherIcon(
                                            weatherModel!.feeling![0]),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          listCheked.clear();
                                          listCheked = [
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false
                                          ];
                                          listCheked[1] = true;
                                        });
                                      },
                                      child: WeeklyItem(
                                        isActive: listCheked[1],
                                        textColor1: textColor1,
                                        textColor2: textColor2,
                                        weekName: weatherModel!.weekDays![1],
                                        weekDay: weatherModel!.days![1],
                                        temp: weatherModel!.tempDay![1],
                                        rain: weatherModel!.rainPerc![1],
                                        image: _weatherIcon(
                                            weatherModel!.feeling![1]),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          listCheked.clear();
                                          listCheked = [
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false
                                          ];
                                          listCheked[2] = true;
                                        });
                                      },
                                      child: WeeklyItem(
                                        isActive: listCheked[2],
                                        textColor1: textColor1,
                                        textColor2: textColor2,
                                        weekName: weatherModel!.weekDays![2],
                                        weekDay: weatherModel!.days![2],
                                        temp: weatherModel!.tempDay![2],
                                        rain: weatherModel!.rainPerc![2],
                                        image: _weatherIcon(
                                            weatherModel!.feeling![2]),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          listCheked.clear();
                                          listCheked = [
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false
                                          ];
                                          listCheked[3] = true;
                                        });
                                      },
                                      child: WeeklyItem(
                                        isActive: listCheked[3],
                                        textColor1: textColor1,
                                        textColor2: textColor2,
                                        weekName: weatherModel!.weekDays![3],
                                        weekDay: weatherModel!.days![3],
                                        temp: weatherModel!.tempDay![3],
                                        rain: weatherModel!.rainPerc![3],
                                        image: _weatherIcon(
                                            weatherModel!.feeling![3]),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (() {
                                        setState(() {
                                          listCheked.clear();
                                          listCheked = [
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false
                                          ];
                                          listCheked[4] = true;
                                        });
                                      }),
                                      child: WeeklyItem(
                                        isActive: listCheked[4],
                                        textColor1: textColor1,
                                        textColor2: textColor2,
                                        weekName: weatherModel!.weekDays![4],
                                        weekDay: weatherModel!.days![4],
                                        temp: weatherModel!.tempDay![4],
                                        rain: weatherModel!.rainPerc![4],
                                        image: _weatherIcon(
                                            weatherModel!.feeling![4]),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          listCheked.clear();
                                          listCheked = [
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false
                                          ];
                                          listCheked[5] = true;
                                        });
                                      },
                                      child: WeeklyItem(
                                        isActive: listCheked[5],
                                        textColor1: textColor1,
                                        textColor2: textColor2,
                                        weekName: weatherModel!.weekDays![5],
                                        weekDay: weatherModel!.days![5],
                                        temp: weatherModel!.tempDay![5],
                                        rain: weatherModel!.rainPerc![5],
                                        image: _weatherIcon(
                                            weatherModel!.feeling![5]),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          listCheked.clear();
                                          listCheked = [
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false
                                          ];
                                          listCheked[6] = true;
                                        });
                                      },
                                      child: WeeklyItem(
                                        isActive: listCheked[6],
                                        textColor1: textColor1,
                                        textColor2: textColor2,
                                        weekName: weatherModel!.weekDays![6],
                                        weekDay: weatherModel!.days![6],
                                        temp: weatherModel!.tempDay![6],
                                        rain: weatherModel!.rainPerc![6],
                                        image: _weatherIcon(
                                            weatherModel!.feeling![6]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Error',
                        style: kTextStyle(size: 18),
                      ),
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child:CircularProgressIndicator(
                        color:  Colors.white,
                      ),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class WeeklyItem extends StatelessWidget {
  WeeklyItem({
    required this.isActive,
    required this.textColor1,
    required this.textColor2,
    required this.weekName,
    required this.weekDay,
    required this.temp,
    required this.rain,
    required this.image,
    Key? key,
  }) : super(key: key);

  bool isActive = false;
  final Color textColor1;
  final Color textColor2;
  String weekName;
  String weekDay;
  String temp;
  String rain;
  String image;

  Color getColorTemp(String temperatura) {
    int son = int.parse(temperatura.replaceAll("+", '').replaceAll('°', ""));
    if (son < 3) {
      return const Color(0xffa5fcfc);
    } else if (son >= 3 && son < 15) {
      return Color(0xffa563fc);
    } else if (son >= 15 && son < 36) {
      return const Color(0xff2DBE8D);
    } else if (son >= 36) {
      return const Color(0xffFFA500);
    } else {
      return const Color(0xff3f63fc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        gradient: isActive ? containerWeatherGradient : null,
        borderRadius: BorderRadius.circular(35),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xff5F68ED).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(2, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Text(
            weekName,
            style: kTextStyle(
                size: 12,
                color: isActive ? null : textColor1,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            weekDay,
            style: kTextStyle(
                size: 10,
                color: isActive ? null : textColor2,
                fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Image.asset(
              image,
              height: 40,
              width: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 3),
            child: Text(
              temp,
              style: kTextStyle(
                  size: 16,
                  color: isActive ? null : textColor1,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            alignment: Alignment.center,
            constraints: const BoxConstraints(
              minWidth: 30,
            ),
            decoration: BoxDecoration(
              color: getColorTemp(temp),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              rain,
              style: kTextStyle(size: 12, fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}

class WeatherInfoBox extends StatelessWidget {
  WeatherInfoBox({
    Key? key,
    required this.textColor1,
    required this.textColor2,
    required this.pess,
    required this.pessSum,
    required this.wind,
    required this.windSum,
    required this.sun,
    required this.sunSum,
    required this.moon,
    required this.moonSum,
    required this.rain,
    required this.rainSum,
    required this.sunset,
    required this.sunsetSum,
    required this.pressed,
  }) : super(key: key);

  final Color textColor1;
  final Color textColor2;
  String pess;
  String pessSum;
  String wind;
  String windSum;
  String sun;
  String sunSum;
  String moon;
  String moonSum;
  String rain;
  String rainSum;
  String sunset;
  String sunsetSum;
  String pressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff555555).withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(5, 15),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/water.png',
                height: 30,
                width: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  pressed,
                  style: kTextStyle(
                      color: textColor1, size: 18, fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff9A60E5).withOpacity(0.16),
                        blurRadius: 30,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/ic_refresh.png',
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoItem(
                  textColor2: textColor2,
                  textColor1: textColor1,
                  icon: 'pess',
                  title: pess,
                  subTitle: pessSum,
                ),
                InfoItem(
                  textColor2: textColor2,
                  textColor1: textColor1,
                  icon: 'wind',
                  title: wind,
                  subTitle: windSum,
                ),
                InfoItem(
                  textColor2: textColor2,
                  textColor1: textColor1,
                  icon: 'sun',
                  title: sun,
                  subTitle: sunSum,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoItem(
                textColor2: textColor2,
                textColor1: textColor1,
                icon: 'moon',
                title: moon,
                subTitle: moonSum,
              ),
              InfoItem(
                textColor2: textColor2,
                textColor1: textColor1,
                icon: 'rain',
                title: rain,
                subTitle: rainSum,
              ),
              InfoItem(
                textColor2: textColor2,
                textColor1: textColor1,
                icon: 'sunset',
                title: sunset,
                subTitle: sunsetSum,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  const InfoItem(
      {Key? key,
      required this.textColor2,
      required this.textColor1,
      required this.icon,
      required this.title,
      required this.subTitle})
      : super(key: key);

  final Color textColor2;
  final Color textColor1;
  final String icon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/$icon.png',
          height: 25,
          width: 25,
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: kTextStyle(
                  size: 10, fontWeight: FontWeight.w700, color: textColor2),
            ),
            Text(
              subTitle,
              style: kTextStyle(
                  size: 10, fontWeight: FontWeight.bold, color: textColor1),
            ),
          ],
        )
      ],
    );
  }
}

class WaetherMainBox extends StatelessWidget {
  WaetherMainBox({
    Key? key,
    required this.obhavo,
    required this.day,
    required this.night,
    required this.today,
    required this.image,
  }) : super(key: key);

  String obhavo;
  String day;
  String night;
  String today;
  String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          margin: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            gradient: containerWeatherGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff5264F0).withOpacity(0.31),
                blurRadius: 30,
                offset: const Offset(10, 15),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 116),
                child: Text(
                  obhavo,
                  style: kTextStyle(size: 24, fontWeight: FontWeight.w700),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GradientText(
                    day,
                    style: kTextStyle(size: 55, fontWeight: FontWeight.bold),
                    gradient: textWeatherGradient,
                  ),
                  Text(
                    '$obhavo $night',
                    style: kTextStyle(size: 15, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          child: Image.asset(
            image,
            height: 160,
            width: 160,
          ),
        ),
        Positioned(
          top: 50,
          right: 20,
          child: Text(
            today.replaceAll(",", "\n"),
            style: kTextStyle(size: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

String _weatherIcon(String? position) {
  if (position!.trim().contains('Ясно')) {
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
