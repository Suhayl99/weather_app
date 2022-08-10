import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/utils/hive_utils.dart';
import '../utils/constans.dart';
import '../provider/provider.dart';
import 'ui_weather/weather_info.dart';
import 'ui_weather/weather_mainbox.dart';
import 'ui_weather/week_item.dart';

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
