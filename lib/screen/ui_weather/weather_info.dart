import 'package:flutter/material.dart';
import '../../utils/constans.dart';
import 'info_item.dart';

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