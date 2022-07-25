import 'dart:developer';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloth_day/main.dart';
import 'package:sloth_day/widgets/dialog_filter_days_off.dart';

import '../const.dart';

class SharedPrefManager{
  static getStartEndDayOffFilter() async {
    DayOffDateFilter? _selectedFilter = DayOffDateFilter.byDateStart;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dayOffFilterPref = prefs.getString(startEndDayOffFilterPrefKey);
    log("dayOffFilterPref from shared: $dayOffFilterPref");
    if (dayOffFilterPref != null){
      _selectedFilter = EnumToString.fromString(DayOffDateFilter.values, dayOffFilterPref);
      log("[SharedPrefManager] Loaded FilterDaysOffDialogsAction: $_selectedFilter");
    }
    return _selectedFilter;
  }

  static setStartEndDayOffFilter(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(startEndDayOffFilterPrefKey,
        EnumToString.convertToString(value));
    log("[SharedPrefManager] Saved FilterDaysOffDialogsAction: $value");
  }

  static getPastFutureDayOffFilter() async {
    FilterDaysOffDialogsAllPastFuture? _selectedFilter = FilterDaysOffDialogsAllPastFuture.allDays;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pastFutureDayOffFilterPref = prefs.getString(pastFutureDayOffFilterPrefKey);
    log("dayOffFilterPref from shared: $pastFutureDayOffFilterPref");
    if (pastFutureDayOffFilterPref != null){
      _selectedFilter = EnumToString.fromString(FilterDaysOffDialogsAllPastFuture.values, pastFutureDayOffFilterPref);
      log("[SharedPrefManager] Loaded pastFutureDayOffFilterPref: $_selectedFilter");
    }
    return _selectedFilter;
  }

  static setPastFutureDayOffFilter(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(pastFutureDayOffFilterPrefKey,
        EnumToString.convertToString(value));
    log("[SharedPrefManager] Saved pastFutureDayOffFilterPrefKey: $value");
  }

  static getDatabaseLocation() async {
    DatabaseLocation? _location = DatabaseLocation.unknown;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _locationAsString = prefs.getString(locationAskedPrefKey);
    if (_locationAsString != null){
      _location = EnumToString.fromString(DatabaseLocation.values, _locationAsString);
    }
    log("[SharedPrefManager] Loaded database location: $_location");
    return _location;
  }

  static setDatabaseLocation(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(locationAskedPrefKey,
        EnumToString.convertToString(value));
    log("[SharedPrefManager] Saved database location: $value");
  }

  // static hasStorageRequestBeenAsked() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? storageRequestBeenAsked = prefs.getBool(storageAskedPrefKey);
  //   log("storageRequestBeenAsked from shared: $storageRequestBeenAsked");
  //   if (storageRequestBeenAsked != null) {
  //     return storageRequestBeenAsked;
  //   }
  //   return false;
  // }
  //
  // static setStorageRequestBeenAsked(value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool(storageAskedPrefKey, value);
  //   log("[SharedPrefManager] Saved storageAskedPrefKey: $value");
  // }
}