import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/hive_utils.dart';
import 'package:weather_app/weather_model.dart';

import 'constans.dart';
import 'provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HiveUtil {
  
  
  @override
  Widget build(BuildContext context) {
  var providerWatch=context.watch<WeatherProvider>();
  var providerRead=context.read<WeatherProvider>();
  return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: scaffoldWeatherGradient,
          ),
          child: SafeArea(
            child: Column(
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
                                        value: providerWatch.value!,
                                        items: providerWatch.cityName
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
                                            providerRead.getValue(item!);                                         
                                            providerRead.getWeather(item);
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
                                image: providerRead.weatherIcon(providerWatch.weatherModel.today![5]),
                                today: providerWatch.weatherModel.today![2],
                                day: providerWatch.weatherModel.today![3],
                                night: providerWatch.weatherModel.today![4],
                                obhavo: providerWatch.weatherModel.today![5],
                              ),
                              WeatherInfoBox(
                                pressed:
                                    "${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}",
                                textColor1: textColor1,
                                textColor2: textColor2,
                                pess: providerWatch.weatherModel.today![6].split(':').first,
                                pessSum: providerWatch.weatherModel.today![6].split(':').last,
                                wind: providerWatch.weatherModel.today![7].split(':').first,
                                windSum: providerWatch.weatherModel.today![7].split(':').last,
                                sun: providerWatch.weatherModel.today![8].split(':').first,
                                sunSum: providerWatch.weatherModel.today![8].split(':').last,
                                moon: providerWatch.weatherModel.today![9].split(':').first,
                                moonSum: providerWatch.weatherModel.today![9].split(':').last,
                                rain: providerWatch.weatherModel.today![10].split(':').first,
                                rainSum: providerWatch.weatherModel.today![10].split(':').last,
                                sunset: providerWatch.weatherModel.today![6].split(':').first,
                                sunsetSum:
                                    providerWatch.weatherModel.today![6].split(':').last,
                              ),
                              Text(
                               providerWatch.weatherModel.today![0],
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
                                         providerRead.getListChecked(0);
                                        },
                                        child: WeeklyItem(
                                          isActive: providerWatch.listCheked[0],
                                          textColor1: textColor1,
                                          textColor2: textColor2,
                                          weekName: providerWatch.weatherModel.weekDays![0],
                                          weekDay: providerWatch.weatherModel.days![0],
                                          temp: providerWatch.weatherModel.tempDay![0],
                                          rain: providerWatch.weatherModel.rainPerc![0],
                                          image: providerRead.weatherIcon(
                                              providerWatch.weatherModel.feeling![0]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          providerRead.getListChecked(1);
                                        },
                                        child: WeeklyItem(
                                          isActive: providerWatch.listCheked[1],
                                          textColor1: textColor1,
                                          textColor2: textColor2,
                                          weekName: providerWatch.weatherModel.weekDays![1],
                                          weekDay: providerWatch.weatherModel.days![1],
                                          temp: providerWatch.weatherModel.tempDay![1],
                                          rain: providerWatch.weatherModel.rainPerc![1],
                                          image: providerRead.weatherIcon(
                                              providerWatch.weatherModel.feeling![1]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          providerRead.getListChecked(2);
                                        },
                                        child: WeeklyItem(
                                          isActive: providerWatch.listCheked[2],
                                          textColor1: textColor1,
                                          textColor2: textColor2,
                                          weekName: providerWatch.weatherModel.weekDays![2],
                                          weekDay: providerWatch.weatherModel.days![2],
                                          temp: providerWatch.weatherModel.tempDay![2],
                                          rain: providerWatch.weatherModel.rainPerc![2],
                                          image: providerRead.weatherIcon(
                                              providerWatch.weatherModel.feeling![2]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                         providerRead.getListChecked(3);
                                        },
                                        child: WeeklyItem(
                                          isActive: providerWatch.listCheked[3],
                                          textColor1: textColor1,
                                          textColor2: textColor2,
                                          weekName: providerWatch.weatherModel.weekDays![3],
                                          weekDay: providerWatch.weatherModel.days![3],
                                          temp: providerWatch.weatherModel.tempDay![3],
                                          rain: providerWatch.weatherModel.rainPerc![3],
                                          image: providerRead.weatherIcon(
                                              providerWatch.weatherModel.feeling![3]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (() {
                                          providerRead.getListChecked(4);
                                        }),
                                        child: WeeklyItem(
                                          isActive: providerWatch.listCheked[4],
                                          textColor1: textColor1,
                                          textColor2: textColor2,
                                          weekName: providerWatch.weatherModel.weekDays![4],
                                          weekDay: providerWatch.weatherModel.days![4],
                                          temp: providerWatch.weatherModel.tempDay![4],
                                          rain: providerWatch.weatherModel.rainPerc![4],
                                          image: providerWatch.weatherIcon(
                                              providerWatch.weatherModel.feeling![4]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          providerRead.getListChecked(5);
                                        },
                                        child: WeeklyItem(
                                          isActive: providerWatch.listCheked[5],
                                          textColor1: textColor1,
                                          textColor2: textColor2,
                                          weekName: providerWatch.weatherModel.weekDays![5],
                                          weekDay: providerWatch.weatherModel.days![5],
                                          temp: providerWatch.weatherModel.tempDay![5],
                                          rain: providerWatch.weatherModel.rainPerc![5],
                                          image: providerRead.weatherIcon(
                                              providerWatch.weatherModel.feeling![5]),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                        providerRead.getListChecked(6);
                                        },
                                        child: WeeklyItem(
                                          isActive: providerWatch.listCheked[6],
                                          textColor1: textColor1,
                                          textColor2: textColor2,
                                          weekName: providerWatch.weatherModel.weekDays![6],
                                          weekDay: providerWatch.weatherModel.days![6],
                                          temp: providerWatch.weatherModel.tempDay![6],
                                          rain: providerWatch.weatherModel.rainPerc![6],
                                          image: providerRead.weatherIcon(
                                              providerWatch.weatherModel.feeling![6]),
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
                    ),
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
      return const Color(0xffa563fc);
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
          height: 20,
          width: 20,
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
                  size: 8, fontWeight: FontWeight.w700, color: textColor2),
            ),
            Text(
              subTitle,
              style: kTextStyle(
                  size: 9, fontWeight: FontWeight.bold, color: textColor1),
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
                  obhavo.length >10 ? "${obhavo.substring(0,10)}\n${obhavo.substring(10)}"  : obhavo,
                  style: kTextStyle(size: 24, fontWeight: FontWeight.w700),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GradientText(
                    day,
                    style: kTextStyle(size: 50, fontWeight: FontWeight.bold),
                    gradient: textWeatherGradient,
                  ),
                  Text(
                    '$night',
                    style: kTextStyle(size: 18, fontWeight: FontWeight.w500),
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


