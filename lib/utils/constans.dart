import 'package:flutter/material.dart';

const String weatherBox = 'weather_box';
const String weatherModelKey = 'weather_model_key';
const String dateKey = 'date_key';
const String dateBox = 'date_box';
  Color textColor1 = const Color(0xff25272E);
   Color textColor2 = const Color.fromRGBO(203, 203, 203, 1);
const scaffoldWeatherGradient = LinearGradient(colors: [Color(0xffFEF7FF), Color(0xffFCEBFF)]);
const textWeatherGradient =
    LinearGradient(colors: [Color(0xffFFFFFF), Color(0xffD2C4FF)], transform: GradientRotation(45));
const containerWeatherGradient =
    LinearGradient(colors: [Color(0xffE662E5), Color(0xff5364F0)], transform: GradientRotation(45));


Color topCityColor = const Color(0xFF25272E);
Color dateTextColor = const Color(0xFFF0F0F0);
Color humidityGoodClr = const Color(0xFF2DBE8D);
Color humidityHmColor = const Color(0xFFF9CF5F);
Color humidityBadClrg = const Color(0xFFFF7676);
Color notActiveDateColor = const Color(0xFFB5B5B5);
Color white = Colors.white;
Color black = Colors.black;


TextStyle kTextStyle(
    {Color? color, double size = 14, FontWeight fontWeight = FontWeight.w500, double? letterSpacing, double? height}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: size,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height);
}




ButtonStyle buttonStyle({
  Color? color,
  Color? shadowColor,
  double? elevation,
  EdgeInsets? padding,
  double? borderRadius,
  BorderSide? side,
  Size? size,
}) {
  return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(color),
      shadowColor: MaterialStateProperty.all(shadowColor),
      elevation: MaterialStateProperty.all(elevation),
      padding: MaterialStateProperty.all(padding),
      minimumSize: MaterialStateProperty.all(size),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 0), side: side ?? BorderSide.none),
      ));
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    Key? key,
    required this.gradient,
    this.style,
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

LinearGradient stateGradient = const LinearGradient(
  colors: [
    Color(0xFFE662E5),
    Color(0xFF5364F0),
  ],
);

BoxDecoration activeDay = BoxDecoration(
  borderRadius: BorderRadius.circular(33),
  gradient: stateGradient,
);

BoxDecoration noActiveDay = BoxDecoration(
  borderRadius: BorderRadius.circular(33),
);