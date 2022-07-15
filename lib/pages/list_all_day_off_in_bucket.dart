import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sloth_day/hive_boxes.dart';
import 'package:sloth_day/models/bucket.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';
import 'package:sloth_day/widgets/day_off_card.dart';
import 'package:sloth_day/widgets/dialog_filter_days_off.dart';

import '../widgets/filtered_day_off_list.dart';

class ListDayOff extends StatefulWidget{

  final Bucket bucket;
  final FilterDaysOffDialogsAction? filter;

  const ListDayOff({Key? key, required this.bucket, this.filter }) : super(key: key);

  @override
  _ListDayOffState createState() => _ListDayOffState();

}

class _ListDayOffState extends State<ListDayOff> {

  callback(){
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/sloth5.png"),
            fit: BoxFit.fitWidth),
      ),
      child: ValueListenableBuilder<Box<DayOff>>(
        valueListenable: Boxes.getDayOffs().listenable(),
        builder: (context, box, _) {
          final daysOff = box.values.where((dayOff) => isDayOffPartOfTheCurrentBucket(dayOff));
          return FilteredDayOffList(bucket: widget.bucket,
              filter: widget.filter,
              listDayOff: daysOff);
        },
      ),
    );
  }

  bool isDayOffPartOfTheCurrentBucket(DayOff dayOff) {
    for (Pool pool in widget.bucket.pools!.castHiveList().cast<Pool>()){
      if (pool.dayOffList!.contains(dayOff)){
        return true;
      }
    }
    return false;
  }
}
