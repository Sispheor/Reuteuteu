import 'package:flutter/material.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:hive/hive.dart';
part 'pool.g.dart';

@HiveType(typeId: 2)
class Pool extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  double maxDays;
  @HiveField(2)
  HiveList? dayOffList;
  @HiveField(3, defaultValue: Colors.green)
  Color color;

  Pool(this.name, this.maxDays, {this.color = Colors.green});

  double getTotalTakenDays() {
    if (dayOffList == null || dayOffList!.isEmpty){
      return 0;
    }else{
      double takenDay = 0;
      for (DayOff dayOff in dayOffList!.castHiveList()){
        takenDay += dayOff.getTotalTakenDays();
      }
      return takenDay;
    }
  }

  double getAvailableDays() {
    return maxDays - getTotalTakenDays();
  }

}
