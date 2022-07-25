
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sloth_day/models/bucket.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';



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