import 'package:reuteuteu/models/day_off.dart';
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

  Pool(this.name, this.maxDays);

  double getTotalTakenDays() {
    if (dayOffList == null){
      return 0;
    }
    double takenDay = 0;
    for (DayOff dayOff in dayOffList!.castHiveList()){
      takenDay += dayOff.getTotalTakenDays();
    }
    return takenDay;
  }

  double getAvailableDays() {
    return maxDays - getTotalTakenDays();
  }

}

