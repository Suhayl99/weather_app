import 'package:flutter/material.dart';
import '../../utils/constans.dart';

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
