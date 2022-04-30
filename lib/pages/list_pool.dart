import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reuteuteu/hive_boxes.dart';
import 'package:reuteuteu/models/bucket.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/create_or_edit_pool.dart';
import 'package:reuteuteu/widgets/consumption_gauge.dart';
import 'package:reuteuteu/widgets/day_off_card.dart';
import 'package:reuteuteu/widgets/pool_card.dart';


class ListPoolPage extends StatefulWidget {

  final Bucket bucket;

  const ListPoolPage({Key? key,
    required this.bucket
  }) : super(key: key);

  @override
  _ListPoolPageState createState() => _ListPoolPageState();
}

class _ListPoolPageState extends State<ListPoolPage>{

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
      const Icon(
        Icons.camera,
        size: 150,
      ),
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

class ListDayOff extends StatefulWidget{

  final Bucket bucket;

  const ListDayOff({Key? key, required this.bucket }) : super(key: key);

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
        // final daysOff = box.values.toList().cast<DayOff>();
        final daysOff = box.values.where((dayOff) => isDayOffPartOfTheCurrentBucket(dayOff));
        if (daysOff.isEmpty) {
          return const Center(
            child: Text(
              'No day off taken',
              style: TextStyle(fontSize: 24),
            ),
          );
        }else{
          return ListView(
            children: daysOff.map((dayOff) => DayOffCardWidget(dayOff: dayOff, callback: callback, pool: _getPoolOfDayOff(dayOff))).toList(),
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


class ListPool extends StatefulWidget{

  final Bucket bucket;

  const ListPool({Key? key, required this.bucket }) : super(key: key);

  @override
  _ListPoolState createState() => _ListPoolState();

}

class _ListPoolState extends State<ListPool>{

  late Bucket bucket;

  callback(){
    setState(() {
      bucket = Boxes.getBuckets().get(widget.bucket.key)!;
      // log("Number of pool in the bucket: ${widget.bucket.pools?.length}");
    });
  }

  @override
  void initState() {
    bucket = Boxes.getBuckets().get(widget.bucket.key)!;
    log("Number of pool in the bucket: ${bucket.pools?.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        if (bucket.pools!.isNotEmpty)
          Card(
              child: SizedBox(
                  height: 150,
                  child: ConsumptionGauge(max: bucket.getPoolMaxDays(), available: bucket.getAvailable())
              )
          ),
        Expanded(
          child: ValueListenableBuilder<Box<Pool>>(
            valueListenable: Boxes.getPools().listenable(),
            builder: (context, box, _) {
              final pools = box.values.where((element) => bucket.pools!.contains(element));
              if (pools.isEmpty) {
                return const Center(
                  child: Text(
                    'No pool yet',
                    style: TextStyle(fontSize: 24),
                  ),
                );
              }else{
                return  ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: pools.cast<Pool>().map((pool) => PoolCardWidget(bucket: bucket, pool: pool, callback: callback)).toList(),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
