import 'package:flutter/material.dart';
import '../../utils/constans.dart';

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