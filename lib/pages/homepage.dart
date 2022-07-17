import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:sloth_day/models/bucket.dart';
import 'package:sloth_day/pages/calendar_view.dart';
import 'package:sloth_day/pages/create_or_edit_pool.dart';
import 'package:sloth_day/pages/list_all_day_off_in_bucket.dart';
import 'package:sloth_day/pages/list_pool.dart';

import '../utils/shared_preferences _manager.dart';
import '../widgets/dialog_filter_days_off.dart';


class HomePage extends StatefulWidget {

  final Bucket bucket;

  const HomePage({Key? key,
    required this.bucket
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  int _selectedIndex = 0;
  final PageController controller = PageController();
  DayOffDateFilter? selectedStartEndDayOffFilter;
  FilterDaysOffDialogsAllPastFuture? selectedPastFutureDayOffFilter;

  callback(){
    setState(() {
      // this debug force the update of the widget
      log("New pool length: ${widget.bucket.pools?.length}");
    });
  }

  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncLoadDayOffFilters();
    });
  }

  _asyncLoadDayOffFilters() async {
    var _selectedStartEndFilter = await SharedPrefManager.getStartEndDayOffFilter();
    var _selectedPastFutureFilter = await SharedPrefManager.getPastFutureDayOffFilter();
    setState(() {
      selectedStartEndDayOffFilter = _selectedStartEndFilter;
      selectedPastFutureDayOffFilter = _selectedPastFutureFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      ListPool(bucket: widget.bucket),
      CalendarPage(bucket: widget.bucket),
      ListDayOff(bucket: widget.bucket, startEndDayOffFilter: selectedStartEndDayOffFilter, pastFutureDayOffFilter: selectedPastFutureDayOffFilter),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: NordColors.polarNight.darkest,
        title: Text("Bucket ${widget.bucket.name}"),
        actions: <Widget>[
          if (_selectedIndex == 2)
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () async {
                final action = await FilterDaysOffDialogs.selectFilterDialog(context);
                if (action != FilterDaysOffAction.canceled){
                  setState(() {
                    _asyncLoadDayOffFilters();
                  });
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CreateOrEditPoolPage(isEdit: false, bucket: widget.bucket))).then((_) => setState(() {}));
            },
          )
        ],
      ),
      body:  PageView(
        controller: controller,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Pools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Days off',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedIconTheme: const IconThemeData(color: Colors.green, size: 40),
      ),
    );
  }

  void _onItemTapped(int index) {
    controller.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }
}


