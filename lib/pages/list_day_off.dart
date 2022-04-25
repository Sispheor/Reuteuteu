import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:reuteuteu/hive_boxes.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/create_or_edit_day_off.dart';
import 'package:reuteuteu/widgets/ConsumptionGauge.dart';
import 'package:reuteuteu/widgets/day_off_card.dart';


class ListDayOffPage extends StatefulWidget {

  Pool pool;

  ListDayOffPage({Key? key,
    required this.pool}) : super(key: key);

  @override
  _ListDayOffPageState createState() => _ListDayOffPageState();
}

class _ListDayOffPageState extends State<ListDayOffPage>{

  List<DayOff> listDayOffs = [];
  late Pool? currentPoolUpdated = Boxes.getPools().get(widget.pool.key);

  void getDayOffs() {
    currentPoolUpdated = Boxes.getPools().get(widget.pool.key);
    currentPoolUpdated!.save();
    if (currentPoolUpdated != null && currentPoolUpdated!.dayOffList != null){
      if (currentPoolUpdated!.dayOffList!.isNotEmpty){
        setState(() {
          listDayOffs = currentPoolUpdated!.dayOffList!.castHiveList().cast<DayOff>();
        });
      }else{
        setState(() {
          listDayOffs = [];
        });
      }
    }
  }

  @override
  void initState() {
    getDayOffs();
    super.initState();
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
                  MaterialPageRoute(builder: (_) => CreateOrEditDayOffPage(isEdit: false, pool: widget.pool, callback: getDayOffs))
              ).then((_) => setState(() {}));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Card(
              // margin: const EdgeInsets.all(10.0),
              child: Container(
                  height: 150,
                  // child: _buildGauge(currentPoolUpdated!)
                  child: ConsumptionGauge(max: currentPoolUpdated!.maxDays, available: currentPoolUpdated!.getAvailableDays())
              )
          ),
          Expanded(
            child: ValueListenableBuilder<Box<Pool>>(
              valueListenable: Boxes.getPools().listenable(),
              builder: (context, box, _) {
                if (listDayOffs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No day off',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }else{
                  return ListView(
                    // children: widget.pool.dayOffList!.castHiveList().cast<DayOff>().map((dayOff) => DayOffCardWidget(dayOff: dayOff)).toList(),
                    children: listDayOffs.map((dayOff) => DayOffCardWidget(dayOff: dayOff, pool: widget.pool, callback: getDayOffs)).toList(),
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
