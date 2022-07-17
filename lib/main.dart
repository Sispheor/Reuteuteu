import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sloth_day/adapters.dart';
import 'package:sloth_day/pages/list_bucket.dart';
import 'package:sloth_day/utils/shared_preferences%20_manager.dart';
import 'package:sloth_day/utils/external_storage.dart';
import 'const.dart';
import 'models/bucket.dart';
import 'models/day_off.dart';
import 'models/pool.dart';

Future<void> createTestingData(Box<Bucket> bucketBox, Box<Pool> poolBox, Box<DayOff> dayOffBox) async {
  // clear boxes
  await bucketBox.clear();
  await poolBox.clear();
  await dayOffBox.clear();
  // testing data
  // create buckets
  var bucket2021 = Bucket('2022/2023');
  bucketBox.addAll([bucket2021]);

  // create pools
  var paidVacation = Pool("Paid vacation", 25, color: Colors.blue);
  var rtt = Pool("RTT", 10, color: Colors.green);
  var seniority = Pool("Seniority ", 3, color: Colors.pink);
  poolBox.addAll([paidVacation, rtt, seniority]);  // add the pools to the database
  bucket2021.pools = HiveList(poolBox);  // create a HiveList
  bucket2021.pools?.addAll([paidVacation, rtt, seniority]);
  bucket2021.save(); // make persistent the changes

  // create couple days off
  var vacation1 = DayOff("Christmas leave", DateTime.utc(2022, 12, 26), DateTime.utc(2022, 12, 30), false, color: paidVacation.color);
  var vacation2 = DayOff("Summer holidays week1", DateTime.utc(2022, 8, 8), DateTime.utc(2022, 8, 12), false, color: paidVacation.color);
  var vacation3 = DayOff("Summer holidays week2", DateTime.utc(2022, 8, 15), DateTime.utc(2022, 8, 19), false, color: paidVacation.color);
  var vacation4 = DayOff("Scuba diving", DateTime.utc(2022, 5, 19), DateTime.utc(2022, 5, 20), false, color: rtt.color);
  var vacation5 = DayOff("Hike", DateTime.utc(2022, 6, 13), DateTime.utc(2022, 6, 13), true, color: seniority.color);
  dayOffBox.addAll([vacation1, vacation2, vacation3, vacation4, vacation5]); // save to the db

  // place days off in different pools
  paidVacation.dayOffList = HiveList(dayOffBox);
  paidVacation.dayOffList?.addAll([vacation1, vacation2, vacation3]);
  paidVacation.save();

  rtt.dayOffList = HiveList(dayOffBox);
  rtt.dayOffList?.addAll([vacation4]);
  rtt.save();

  seniority.dayOffList = HiveList(dayOffBox);
  seniority.dayOffList?.addAll([vacation5]);
  seniority.save();
  // end testing data
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool useLocalDb = true;
  // check if we got an access to external storage
  var status = await Permission.manageExternalStorage.status;
  if (status.isDenied && await SharedPrefManager.hasStorageRequestBeenAsked()) {
    log("manageExternalStorage perm is not granted and already been asked");
    useLocalDb = true;
  }else{
    // if (await Permission.storage.request().isGranted && await Permission.manageExternalStorage.request().isGranted) {
    // try to get local access
    if (await Permission.manageExternalStorage.request().isGranted) {
      useLocalDb = false;
      // Either the permission was already granted before or the user just granted it.
      log("External storage allowed. Placing files in Documents");
      // create a directory for the db
      String createdPath = await ExtStorage.createFolderInPublicDir(
        type: ExtPublicDir.Documents,
        folderName: dbFolderName,
      );
      await Hive.initFlutter(createdPath);
    }else{
      log("External storage not allowed. Placing files in app folder");
      Fluttertoast.showToast(
        msg: "Database files will not be reachable from external apps to be saved",  // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER,    // location
      );
      SharedPrefManager.setStorageRequestBeenAsked(true);
    }
  }

  if (useLocalDb){
    // local
    await Hive.initFlutter();
  }

  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(DayOffAdapter());
  Hive.registerAdapter(PoolAdapter());
  Hive.registerAdapter(BucketAdapter());

  var bucketBox = await Hive.openBox<Bucket>('buckets');
  var poolBox = await Hive.openBox<Pool>('pools');
  var dayOffBox = await Hive.openBox<DayOff>('day_offs');

  // if (kDebugMode){
  //   log("App started with debug mode. Creating testing data");
  //   createTestingData(bucketBox, poolBox, dayOffBox);
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Sloth',
      themeMode: ThemeMode.dark, // Or [ThemeMode.dark]
      theme: NordTheme.light(),
      darkTheme: NordTheme.dark(),
      home: const ListBucketPage(),
    );
  }
}
