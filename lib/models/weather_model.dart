import 'package:hive/hive.dart';
part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WatherModel extends HiveObject {
  @HiveField(0)
  String? date;
  @HiveField(1)
  List<String>? today;
  @HiveField(2)
  List<String>? weekDays;
  @HiveField(3)
  List<String>? days;
  @HiveField(4)
  List<String>? tempDay;
  @HiveField(5)
  List<String>? tempNight;
  @HiveField(6)
  List<String>? feeling;
  @HiveField(7)
  List<String>? rainPerc;

  WatherModel(
      {this.date,
      this.today,
      this.weekDays,
      this.days,
      this.tempDay,
      this.tempNight,
      this.feeling,
      this.rainPerc});

  WatherModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    today = json['today'].cast<String>();
    weekDays = json['weekDays'].cast<String>();
    days = json['days'].cast<String>();
    tempDay = json['tempDay'].cast<String>();
    tempNight = json['tempNight'].cast<String>();
    feeling = json['feeling'].cast<String>();
    rainPerc = json['rainPerc'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['today'] = today;
    data['weekDays'] = weekDays;
    data['days'] = days;
    data['tempDay'] = tempDay;
    data['tempNight'] = tempNight;
    data['feeling'] = feeling;
    data['rainPerc'] = rainPerc;
    return data;
  }
}