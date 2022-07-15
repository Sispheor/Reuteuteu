import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/bucket.dart';
import '../models/day_off.dart';
import '../models/pool.dart';
import 'day_off_card.dart';
import 'dialog_filter_days_off.dart';

class FilteredDayOffList extends StatefulWidget {
  final Bucket bucket;
  final Iterable<DayOff> listDayOff;
  final FilterDaysOffDialogsAction? filter;

  const FilteredDayOffList({
    Key? key,
    required this.listDayOff,
    required this.filter, required this.bucket
  }) : super(key: key);

  @override
  _FilteredDayOffListState createState() => _FilteredDayOffListState();

}

class _FilteredDayOffListState extends State<FilteredDayOffList> {

  callback(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final dayOffCopy = [...widget.listDayOff.toList()];
    if (dayOffCopy.isEmpty) {
      return const Center(
        child: Text(
          'No day off',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      if (widget.filter != null && widget.filter == FilterDaysOffDialogsAction.byDateStart) {
        log("Applying new filter: ${widget.filter}");
        dayOffCopy.sort((a, b) => a.dateStart.compareTo(b.dateStart));
        // log(dayOffCopy.toString());
      }
      if (widget.filter != null && widget.filter == FilterDaysOffDialogsAction.byDateEnd) {
        log("Applying new filter: ${widget.filter}");
        dayOffCopy.sort((a, b) => a.dateEnd.compareTo(b.dateEnd));
        // log(dayOffCopy.toString());
      }
      return ListView(
        children: dayOffCopy.map((dayOff) => DayOffCardWidget(dayOff: dayOff, callback: callback, pool: _getPoolOfDayOff(dayOff))).toList(),
      );
    }
  }

  _getPoolOfDayOff(DayOff dayOff) {
    for (Pool pool in widget.bucket.pools!.castHiveList().cast<Pool>()){
      if (pool.dayOffList!.contains(dayOff)){
        return pool;
      }
    }
  }
}