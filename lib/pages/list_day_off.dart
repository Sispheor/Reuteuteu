import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:reuteuteu/hive_boxes.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/create_or_edit_day_off.dart';
import 'package:reuteuteu/widgets/consumption_gauge.dart';
import 'package:reuteuteu/widgets/day_off_card.dart';


class ListDayOffPage extends StatefulWidget {

  final Pool pool;

  const ListDayOffPage({Key? key,
    required this.pool}) : super(key: key);

  @override
  _ListDayOffPageState createState() => _ListDayOffPageState();
}

class _ListDayOffPageState extends State<ListDayOffPage>{

  callback(){
    setState(() {
      // this debug force the update of the widget
      log("New day off list length: ${widget.pool.dayOffList?.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pool ${widget.pool.name}"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CreateOrEditDayOffPage(isEdit: false, pool: widget.pool))).then((_) => setState(() {}));
            },
          )
        ],
      ),
      body: Column(
        children: [
          if (widget.pool.dayOffList != null && widget.pool.dayOffList!.isNotEmpty)
          Card(
              child: SizedBox(
                  height: 150,
                  child: ConsumptionGauge(max: widget.pool.maxDays, available: widget.pool.getAvailableDays())
              )
          ),
          Expanded(
            child: ValueListenableBuilder<Box<DayOff>>(
              valueListenable: Boxes.getDayOffs().listenable(),
              builder: (context, box, _) {
                final listDayOffs = box.values.where((element) => widget.pool.dayOffList!.contains(element));
                if (listDayOffs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No day off',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }else{
                  return ListView(
                    children: listDayOffs.map((dayOff) => DayOffCardWidget(dayOff: dayOff, pool: widget.pool, callback: callback)).toList(),
                  );
                }
              },
            ),
          )
        ],
      ),

    );
  }
}
