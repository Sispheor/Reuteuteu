

import 'dart:developer';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<String> filters = ["byDateStart", "byDateEnd", "byDateCreated", "canceled"];
enum FilterDaysOffDialogsAction { byDateStart, byDateEnd, byDateCreated , canceled }
const String dayOffFilterPrefKey = "day_off_filter";

class FilterDaysOffDialogs {
  static Future<FilterDaysOffDialogsAction> selectFilterDialog(
      BuildContext context,
      ) async {

    log("Enter FilterDaysOffDialogs");
    FilterDaysOffDialogsAction? _selectedFilter = FilterDaysOffDialogsAction.byDateStart;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dayOffFilterPref = prefs.getString(dayOffFilterPrefKey);
    log("dayOffFilterPref from shared: $dayOffFilterPref");
    if (dayOffFilterPref != null){
      _selectedFilter = EnumToString.fromString(FilterDaysOffDialogsAction.values, dayOffFilterPref);
      log("Loaded pref: $_selectedFilter");
    }

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
                            await prefs.setString(dayOffFilterPrefKey,
                                EnumToString.convertToString(value));
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
                            await prefs.setString(dayOffFilterPrefKey,
                                EnumToString.convertToString(value));
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
                            await prefs.setString(dayOffFilterPrefKey,
                                EnumToString.convertToString(value));
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