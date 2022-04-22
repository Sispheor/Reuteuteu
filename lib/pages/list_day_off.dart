import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:reuteuteu/hive_boxes.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/create_or_edit_day_off.dart';
import 'package:reuteuteu/widgets/day_off_card.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class ListDayOffPage extends StatefulWidget {

  Pool pool;

  ListDayOffPage({Key? key,
    required this.pool}) : super(key: key);

  @override
  _ListDayOffPageState createState() => _ListDayOffPageState();
}

class _ListDayOffPageState extends State<ListDayOffPage>{

  List<DayOff> listDayOffs = [];
  late Pool? currentPoolUpdated = Boxes.getPools().getAt(widget.pool.key);

  void getDayOffs() {
    currentPoolUpdated = Boxes.getPools().getAt(widget.pool.key);
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
                  child: _buildDistanceTrackerExample(currentPoolUpdated!)
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

/// Returns the gauge distance tracker
Widget _buildDistanceTrackerExample(Pool currentPoolUpdated) {
  return SfRadialGauge(
    enableLoadingAnimation: true,
    axes: <RadialAxis>[
      RadialAxis(
          showLabels: false,
          showTicks: false,
          radiusFactor: 0.8,
          minimum: 0,
          maximum: currentPoolUpdated.maxDays,
          axisLineStyle: const AxisLineStyle(
              cornerStyle: CornerStyle.startCurve, thickness: 5),
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 90,
                positionFactor: 0,
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(currentPoolUpdated.getAvailableDays().toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 30)),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: Text(
                        'days',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 14),
                      ),
                    )
                  ],
                )),
            const GaugeAnnotation(
              angle: 124,
              positionFactor: 1.1,
              widget: Text('0', style: TextStyle(fontSize: 14)),
            ),
            GaugeAnnotation(
              angle: 54,
              positionFactor: 1.1,
              widget: Text(currentPoolUpdated.maxDays.toString(),
                  style: const TextStyle(fontSize: 14)),
            ),
          ],
          pointers: <GaugePointer>[
            RangePointer(
                value: currentPoolUpdated.getAvailableDays(),
                width: 18,
                pointerOffset: -6,
                cornerStyle: CornerStyle.bothCurve,
                color: Colors.green
            )

          ]),
    ],
  );
}

