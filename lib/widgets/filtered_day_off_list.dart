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
  final DayOffDateFilter? startEndDayOffFilter;
  final FilterDaysOffDialogsAllPastFuture? pastFutureDayOffFilter;
  final VoidCallback? callback;

  const FilteredDayOffList({
    Key? key,
    required this.listDayOff,
    required this.startEndDayOffFilter,
    required this.bucket,
    this.pastFutureDayOffFilter,
    this.callback
  }) : super(key: key);

  @override
  _FilteredDayOffListState createState() => _FilteredDayOffListState();

}

class _FilteredDayOffListState extends State<FilteredDayOffList> {

  callback(){
    setState(() {
      if (widget.callback != null){
        widget.callback!();
      }
    });
  }

  DateTime now = DateTime.now();

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
      if (widget.startEndDayOffFilter != null && widget.startEndDayOffFilter == DayOffDateFilter.byDateStart) {
        log("Applying new filter: ${widget.startEndDayOffFilter}");
        dayOffCopy.sort((a, b) => a.dateStart.compareTo(b.dateStart));
        // log(dayOffCopy.toString());
      }
      if (widget.startEndDayOffFilter != null && widget.startEndDayOffFilter == DayOffDateFilter.byDateEnd) {
        log("Applying new filter: ${widget.startEndDayOffFilter}");
        dayOffCopy.sort((a, b) => a.dateEnd.compareTo(b.dateEnd));
        // log(dayOffCopy.toString());
      }
      if (widget.pastFutureDayOffFilter != null && widget.pastFutureDayOffFilter == FilterDaysOffDialogsAllPastFuture.onlyPastDays){
        log("Applying new filter: ${widget.pastFutureDayOffFilter}");
        dayOffCopy.removeWhere((element) => element.dateStart.isAfter(now));
      }
      if (widget.pastFutureDayOffFilter != null && widget.pastFutureDayOffFilter == FilterDaysOffDialogsAllPastFuture.onlyFutureDays){
        log("Applying new filter: ${widget.pastFutureDayOffFilter}");
        dayOffCopy.removeWhere((element) => element.dateStart.isBefore(now));
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