import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:sloth_day/models/bucket.dart';
import 'package:sloth_day/pages/calendar_view.dart';
import 'package:sloth_day/pages/create_or_edit_pool.dart';
import 'package:sloth_day/pages/list_all_day_off_in_bucket.dart';
import 'package:sloth_day/pages/list_pool.dart';


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

  callback(){
    setState(() {
      // this debug force the update of the widget
      log("New pool length: ${widget.bucket.pools?.length}");
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _pages = <Widget>[
      ListPool(bucket: widget.bucket),
      CalendarPage(bucket: widget.bucket),
      ListDayOff(bucket: widget.bucket),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: NordColors.polarNight.darkest,
        title: Text("Bucket ${widget.bucket.name}"),
        actions: <Widget>[
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
        selectedIconTheme: IconThemeData(color: NordColors.frost.lighter, size: 40),
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


