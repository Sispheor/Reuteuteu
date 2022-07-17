

import 'dart:developer';

import 'package:flutter/material.dart';

import '../utils/shared_preferences _manager.dart';

final List<String> filters = ["byDateStart", "byDateEnd", "byDateCreated", "canceled"];

enum FilterDaysOffAction {changed, canceled}
enum DayOffDateFilter { byDateStart, byDateEnd, byDateCreated }
enum FilterDaysOffDialogsAllPastFuture { allDays, onlyPastDays, onlyFutureDays }


class FilterDaysOffDialogs {
  static Future<DayOffDateFilter> selectFilterDialog(
      BuildContext context,
      ) async {

    log("Enter FilterDaysOffDialogs");
    var _selectedStartEndFilter = await SharedPrefManager.getStartEndDayOffFilter();
    var _selectedAllPastFutureFilter = await SharedPrefManager.getPastFutureDayOffFilter();

    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: const Text("Select filters"),
                  content: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('By date start'),
                        leading: Radio<DayOffDateFilter>(
                          value: DayOffDateFilter.byDateStart,
                          groupValue: _selectedStartEndFilter,
                          onChanged: (DayOffDateFilter? value) async {
                            setState(() {
                              _selectedStartEndFilter = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('By date end'),
                        leading: Radio<DayOffDateFilter>(
                          value: DayOffDateFilter.byDateEnd,
                          groupValue: _selectedStartEndFilter,
                          onChanged: (DayOffDateFilter? value) async {
                            setState(() {
                              _selectedStartEndFilter = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('By creation date'),
                        leading: Radio<DayOffDateFilter>(
                          value: DayOffDateFilter.byDateCreated,
                          groupValue: _selectedStartEndFilter,
                          onChanged: (DayOffDateFilter? value) async {
                            setState(() {
                              _selectedStartEndFilter = value;
                            });
                          },
                        ),
                      ),
                      const Divider(thickness: 3),
                      ListTile(
                        title: const Text('Show all'),
                        leading: Radio<FilterDaysOffDialogsAllPastFuture>(
                          value: FilterDaysOffDialogsAllPastFuture.allDays,
                          groupValue: _selectedAllPastFutureFilter,
                          onChanged: (FilterDaysOffDialogsAllPastFuture? value) async {
                            setState(() {
                              if (value != null){
                                _selectedAllPastFutureFilter = value;
                              }
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Only past days'),
                        leading: Radio<FilterDaysOffDialogsAllPastFuture>(
                          value: FilterDaysOffDialogsAllPastFuture.onlyPastDays,
                          groupValue: _selectedAllPastFutureFilter,
                          onChanged: (FilterDaysOffDialogsAllPastFuture? value) async {
                            setState(() {
                              if (value != null){
                                _selectedAllPastFutureFilter = value;
                              }
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Only future days'),
                        leading: Radio<FilterDaysOffDialogsAllPastFuture>(
                          value: FilterDaysOffDialogsAllPastFuture.onlyFutureDays,
                          groupValue: _selectedAllPastFutureFilter,
                          onChanged: (FilterDaysOffDialogsAllPastFuture? value) async {
                            setState(() {
                              if (value != null){
                                _selectedAllPastFutureFilter = value;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        log("Selected filter: byDateCreated. Saving in pref");
                        await SharedPrefManager.setStartEndDayOffFilter(_selectedStartEndFilter);
                        await SharedPrefManager.setPastFutureDayOffFilter(_selectedAllPastFutureFilter);
                        Navigator.of(context).pop(_selectedStartEndFilter);
                      },
                      child: const Text('Ok'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green
                      ),
                    ),
                  ],
                );}); // here
        }
    );
    return (action != null) ? action : FilterDaysOffAction.canceled;
  }
}