import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/models/bucket.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';


void main() {
  late Bucket bucket2021;
  late Pool payedVacation;
  late Pool rtt;
  late DayOff vacation1;
  late DayOff vacation2;
  late DayOff vacation3;
  bool isRegistered = false;

  setUp(() async {
    await setUpTestHive();
    if (!isRegistered){
      Hive.registerAdapter(DayOffAdapter());
      Hive.registerAdapter(PoolAdapter());
      Hive.registerAdapter(BucketAdapter());
      isRegistered = true;
    }

    var bucketBox = await Hive.openBox<Bucket>('buckets');
    var poolBox = await Hive.openBox<Pool>('pools');
    var dayOffBox = await Hive.openBox<DayOff>('day_offs');

    // create buckets
    bucket2021 = Bucket('2021');
    bucketBox.addAll([bucket2021]);

    // create pools
    payedVacation = Pool("payed_vacation", 25);
    rtt = Pool("rtt", 10);
    poolBox.addAll([payedVacation, rtt]);  // add the pools to the database
    bucket2021.pools = HiveList(poolBox);  // create a HiveList
    bucket2021.pools?.addAll([payedVacation, rtt]);
    bucket2021.save(); // make persistent the changes

    // create couple days off
    vacation1 = DayOff("vac1", DateTime.utc(2021, 1, 1), DateTime.utc(2021, 1, 10), false);
    vacation2 = DayOff("vac2", DateTime.utc(2021, 2, 1), DateTime.utc(2021, 2, 10), false);
    vacation3 = DayOff("vac3", DateTime.utc(2021, 3, 1), DateTime.utc(2021, 3, 5), false);
    dayOffBox.addAll([vacation1, vacation2, vacation3]); // save to the db

    // place days off in different pools
    payedVacation.dayOffList = HiveList(dayOffBox);
    payedVacation.dayOffList?.addAll([vacation1, vacation2]);
    payedVacation.save();

    rtt.dayOffList = HiveList(dayOffBox);
    rtt.dayOffList?.addAll([vacation3]);
    rtt.save();

  });

  tearDown(() async {
    await tearDownTestHive();
    await Hive.close();
  });


  test('Test get total taken days in a DayOff', () {
    expect(10, vacation1.getTotalTakenDays());
    expect(10, vacation2.getTotalTakenDays());
    expect(5, vacation3.getTotalTakenDays());
  });

  test('Test get total taken days in a pool', () {
    expect(20, payedVacation.getTotalTakenDays());
    expect(5, rtt.getTotalTakenDays());
  });

  test('Test get available days in a pool', () {
    expect(5, payedVacation.getAvailableDays());
    expect(5, rtt.getAvailableDays());
  });

  test('Test get taken days in a bucket', () {
    expect(25, bucket2021.getTakenDays());
  });

  test('Test get max days days in a bucket', () {
    expect(35, bucket2021.getPoolMaxDays());
  });

}