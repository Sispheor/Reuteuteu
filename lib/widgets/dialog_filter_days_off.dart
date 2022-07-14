

import 'dart:developer';

import 'package:flutter/material.dart';

import '../shared_preferences _manager.dart';

final List<String> filters = ["byDateStart", "byDateEnd", "byDateCreated", "canceled"];
enum FilterDaysOffDialogsAction { byDateStart, byDateEnd, byDateCreated , canceled }


class FilterDaysOffDialogs {
  static Future<FilterDaysOffDialogsAction> selectFilterDialog(
      BuildContext context,
      ) async {

    log("Enter FilterDaysOffDialogs");
    var _selectedFilter = await SharedPrefManager.getDayOffFilter();

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
                  title: const Text("Select a filter"),
                  content: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('By date start'),
                        leading: Radio<FilterDaysOffDialogsAction>(
                          value: FilterDaysOffDialogsAction.byDateStart,
                          groupValue: _selectedFilter,
                          onChanged: (FilterDaysOffDialogsAction? value) async {
                            setState(() {
                              _selectedFilter = value;
                            });
                            log("Selected filter: byDateStart. Saving in pref");
                            await SharedPrefManager.setDayOffFilter(value);
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('By date end'),
                        leading: Radio<FilterDaysOffDialogsAction>(
                          value: FilterDaysOffDialogsAction.byDateEnd,
                          groupValue: _selectedFilter,
                          onChanged: (FilterDaysOffDialogsAction? value) async {
                            setState(() {
                              _selectedFilter = value;
                            });
                            log("Selected filter: byDateEnd. Saving in pref");
                            await SharedPrefManager.setDayOffFilter(value);
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('By creation date'),
                        leading: Radio<FilterDaysOffDialogsAction>(
                          value: FilterDaysOffDialogsAction.byDateCreated,
                          groupValue: _selectedFilter,
                          onChanged: (FilterDaysOffDialogsAction? value) async {
                            setState(() {
                              _selectedFilter = value;
                            });
                            log("Selected filter: byDateCreated. Saving in pref");
                            await SharedPrefManager.setDayOffFilter(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(_selectedFilter),
                      child: const Text('Ok'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green
                      ),
                    ),
                  ],
                );}); // here
        }
    );
    return (action != null) ? action : FilterDaysOffDialogsAction.canceled;
  }
}