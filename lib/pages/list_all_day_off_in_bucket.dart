import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reuteuteu/hive_boxes.dart';
import 'package:reuteuteu/models/bucket.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/widgets/day_off_card.dart';

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
