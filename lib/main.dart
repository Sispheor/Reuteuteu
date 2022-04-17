import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reuteuteu/pages/homepage.dart';

import 'models/bucket.dart';
import 'models/day_off.dart';
import 'models/pool.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DayOffAdapter());
  Hive.registerAdapter(PoolAdapter());
  Hive.registerAdapter(BucketAdapter());

  var bucketBox = await Hive.openBox<Bucket>('buckets');
  var poolBox = await Hive.openBox<Pool>('pools');
  var dayOffBox = await Hive.openBox<DayOff>('day_offs');

  // testing data
  // // create buckets
  // var bucket2021 = Bucket('2021');
  // bucketBox.addAll([bucket2021]);
  //
  // // create pools
  // var payedVacation = Pool("payed_vacation", 25);
  // var rtt = Pool("rtt", 10);
  // poolBox.addAll([payedVacation, rtt]);  // add the pools to the database
  // bucket2021.pools = HiveList(poolBox);  // create a HiveList
  // bucket2021.pools?.addAll([payedVacation, rtt]);
  // bucket2021.save(); // make persistent the changes
  //
  // // create couple days off
  // var vacation1 = DayOff("vac1", DateTime.utc(2021, 1, 1), DateTime.utc(2021, 1, 10), false);
  // var vacation2 = DayOff("vac2", DateTime.utc(2021, 2, 1), DateTime.utc(2021, 2, 10), false);
  // var vacation3 = DayOff("vac3", DateTime.utc(2021, 3, 1), DateTime.utc(2021, 3, 5), false);
  // dayOffBox.addAll([vacation1, vacation2, vacation3]); // save to the db
  //
  // // place days off in different pools
  // payedVacation.dayOffList = HiveList(dayOffBox);
  // payedVacation.dayOffList?.addAll([vacation1, vacation2]);
  // payedVacation.save();
  //
  // rtt.dayOffList = HiveList(dayOffBox);
  // rtt.dayOffList?.addAll([vacation3]);
  // rtt.save();
  // end testing data

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reuteuteu',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}
