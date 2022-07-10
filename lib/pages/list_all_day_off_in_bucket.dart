import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sloth_day/hive_boxes.dart';
import 'package:sloth_day/models/bucket.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';
import 'package:sloth_day/widgets/day_off_card.dart';
import 'package:sloth_day/widgets/dialog_filter_days_off.dart';

class ListDayOff extends StatefulWidget{

  final Bucket bucket;
  final FilterDaysOffDialogsAction filter;

  const ListDayOff({Key? key, required this.bucket, required this.filter }) : super(key: key);

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

    return ValueListenableBuilder<Box<DayOff>>(
      valueListenable: Boxes.getDayOffs().listenable(),
      builder: (context, box, _) {
        final daysOff = box.values.where((dayOff) => isDayOffPartOfTheCurrentBucket(dayOff));
        final dayOffCopy = [...daysOff.toList()];
        if (daysOff.isEmpty) {
          return const Center(
            child: Text(
              'No day off taken',
              style: TextStyle(fontSize: 24),
            ),
          );
        }else{
          // log("Current filter: ${widget.filter}");
          // log(dayOffCopy.toString());
          if (widget.filter == FilterDaysOffDialogsAction.byDateStart){
            log("Applying new filter: ${widget.filter}");
            dayOffCopy.sort((a, b) => a.dateStart.compareTo(b.dateStart));
            // log(dayOffCopy.toString());
          }
          if (widget.filter == FilterDaysOffDialogsAction.byDateEnd){
            log("Applying new filter: ${widget.filter}");
            dayOffCopy.sort((a, b) => a.dateEnd.compareTo(b.dateEnd));
            // log(dayOffCopy.toString());
          }
          return ListView(
            children: dayOffCopy.map((dayOff) => DayOffCardWidget(dayOff: dayOff, callback: callback, pool: _getPoolOfDayOff(dayOff))).toList(),
          );
        }

      },
    );
  }

  _getPoolOfDayOff(DayOff dayOff) {
    for (Pool pool in widget.bucket.pools!.castHiveList().cast<Pool>()){
      if (pool.dayOffList!.contains(dayOff)){
        return pool;
      }
    }
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
