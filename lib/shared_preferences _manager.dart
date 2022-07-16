

import 'dart:developer';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloth_day/widgets/dialog_filter_days_off.dart';

import 'const.dart';

class SharedPrefManager{
  static getDayOffFilter() async {
    FilterDaysOffDialogsAction? _selectedFilter = FilterDaysOffDialogsAction.byDateStart;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dayOffFilterPref = prefs.getString(dayOffFilterPrefKey);
    log("dayOffFilterPref from shared: $dayOffFilterPref");
    if (dayOffFilterPref != null){
      _selectedFilter = EnumToString.fromString(FilterDaysOffDialogsAction.values, dayOffFilterPref);
      log("[SharedPrefManager] Loaded FilterDaysOffDialogsAction: $_selectedFilter");
      return _selectedFilter;
    }
  }

  static setDayOffFilter(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(dayOffFilterPrefKey,
        EnumToString.convertToString(value));
    log("[SharedPrefManager] Saved FilterDaysOffDialogsAction: $value");
  }

  static hasStorageRequestBeenAsked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? storageRequestBeenAsked = prefs.getBool(storageAskedPrefKey);
    log("storageRequestBeenAsked from shared: $storageRequestBeenAsked");
    if (storageRequestBeenAsked != null) {
      return storageRequestBeenAsked;
    }
    return false;
  }

  static setStorageRequestBeenAsked(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(storageAskedPrefKey, value);
    log("[SharedPrefManager] Saved storageAskedPrefKey: $value");
  }
}