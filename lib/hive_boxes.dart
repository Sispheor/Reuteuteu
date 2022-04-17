import 'package:hive/hive.dart';

import 'models/bucket.dart';
import 'models/day_off.dart';
import 'models/pool.dart';

class Boxes {
  static Box<Bucket> getBuckets() =>
      Hive.box<Bucket>('buckets');
  static Box<Pool> getPools() =>
      Hive.box<Pool>('pools');
  static Box<DayOff> getDayOffs() =>
      Hive.box<DayOff>('day_offs');
}


