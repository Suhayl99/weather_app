import 'package:flutter/material.dart';
import '../../utils/constans.dart';

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