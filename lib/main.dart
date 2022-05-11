import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sloth_day/adapters.dart';
import 'package:sloth_day/pages/list_bucket.dart';

import 'models/bucket.dart';
import 'models/day_off.dart';
import 'models/pool.dart';

void createTestingData(Box<Bucket> bucketBox, Box<Pool> poolBox, Box<DayOff> dayOffBox){
  // testing data
  // create buckets
  var bucket2021 = Bucket('2021');
  bucketBox.addAll([bucket2021]);

  // create pools
  var payedVacation = Pool("CP", 25, color: Colors.red);
  var rtt = Pool("RTT", 10, color: Colors.yellow);
  poolBox.addAll([payedVacation, rtt]);  // add the pools to the database
  bucket2021.pools = HiveList(poolBox);  // create a HiveList
  bucket2021.pools?.addAll([payedVacation, rtt]);
  bucket2021.save(); // make persistent the changes

  // create couple days off
  var vacation1 = DayOff("vac1", DateTime.utc(2022, 1, 1), DateTime.utc(2022, 1, 10), false, color: payedVacation.color);
  var vacation2 = DayOff("vac2", DateTime.utc(2022, 2, 1), DateTime.utc(2022, 2, 10), false, color: payedVacation.color);
  var vacation3 = DayOff("vac3", DateTime.utc(2022, 3, 1), DateTime.utc(2022, 3, 5), false, color: rtt.color);
  var vacation4 = DayOff("vac4", DateTime.utc(2022, 4, 1), DateTime.utc(2022, 4, 1), true, color: rtt.color);
  dayOffBox.addAll([vacation1, vacation2, vacation3, vacation4]); // save to the db

  // place days off in different pools
  payedVacation.dayOffList = HiveList(dayOffBox);
  payedVacation.dayOffList?.addAll([vacation1, vacation2]);
  payedVacation.save();

  rtt.dayOffList = HiveList(dayOffBox);
  rtt.dayOffList?.addAll([vacation3, vacation4]);
  rtt.save();
  // end testing data
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(DayOffAdapter());
  Hive.registerAdapter(PoolAdapter());
  Hive.registerAdapter(BucketAdapter());

  var bucketBox = await Hive.openBox<Bucket>('buckets');
  var poolBox = await Hive.openBox<Pool>('pools');
  var dayOffBox = await Hive.openBox<DayOff>('day_offs');
  await bucketBox.clear();
  await poolBox.clear();
  await dayOffBox.clear();

  if (kDebugMode){
    log("App started with debug mode. Creating testing data");
    createTestingData(bucketBox, poolBox, dayOffBox);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sloth',
      themeMode: ThemeMode.dark, // Or [ThemeMode.dark]
      theme: NordTheme.light(),
      darkTheme: NordTheme.dark(),
      home: const ListBucketPage(),
    );
  }
}
