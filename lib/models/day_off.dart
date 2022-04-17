import 'package:hive/hive.dart';
part 'day_off.g.dart';


@HiveType(typeId: 1)
class DayOff extends HiveObject {

  @HiveField(0)
  late String name;
  @HiveField(1)
  late DateTime dateStart;
  @HiveField(2)
  late DateTime dateEnd;
  @HiveField(3)
  late bool isHalfDay;

  DayOff(this.name, this.dateStart, this.dateEnd, this.isHalfDay);

  @override
  String toString() {
    return 'DayOff{name: $name, '
        'dateStart: $dateStart, dateEnd:$dateEnd, isHalfDay:$isHalfDay}';
  }
  double getTotalTakenDays() {
    if (dateStart == dateEnd){
      if (isHalfDay){
        return 0.5;
      }else{
        return 1;
      }
    }
    int takenDay = dateEnd.difference(dateStart).inDays + 1;  // + 1 because we count the first day
    if (isHalfDay) {
      return takenDay/2;
    }
    return takenDay.toDouble();
  }

  String getTotalTakenDaysAsString() {
    double takenDay = getTotalTakenDays();
    if (takenDay % 1 == 0 ){
      return takenDay.toStringAsFixed(0);
    }
    return takenDay.toString();
  }
}
