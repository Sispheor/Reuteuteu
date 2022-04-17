import 'package:reuteuteu/models/pool.dart';
import 'package:hive/hive.dart';
part 'bucket.g.dart';

@HiveType(typeId: 3)
class Bucket extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  HiveList? pools;

  Bucket(this.name);

  @override
  String toString() => name; // Just for print()


  double getPoolMaxDays(){
    double returnedMaxDays = 0;
    if (pools == null){
      return 0;
    }
    for (Pool pool in pools!.castHiveList()){
      returnedMaxDays += pool.maxDays;
    }
    return returnedMaxDays;
  }

  double getTakenDays() {
    if (pools == null){
      return 0;
    }
    double takenDay = 0;
    for (Pool pool in pools!.castHiveList()){
      takenDay += pool.getTotalTakenDays();
    }
    return takenDay;
  }

  double getAvailable(){
    if (pools == null){
      return 0;
    }
    return getPoolMaxDays() - getTakenDays();

  }

}