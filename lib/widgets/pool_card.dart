import 'package:flutter/material.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/list_day_off.dart';
import 'package:reuteuteu/widgets/ConsumptionGauge.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PoolCardWidget extends StatelessWidget {

  const PoolCardWidget({
    Key? key,
    required this.pool
  }) : super(key: key);

  final Pool pool;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(pool.name),
              subtitle: Container(
                  height: 100,
                  child: SfLinearGauge(
                      interval: pool.maxDays,
                      minimum: 0,
                      maximum: pool.maxDays,
                      markerPointers: [
                        LinearWidgetPointer(
                          position: LinearElementPosition.outside,
                          value: pool.getAvailableDays(),
                          offset: 15,
                          child: Text(pool.getAvailableDays().toString()),
                        ),
                      ],
                      barPointers: [
                        LinearBarPointer(value: pool.getAvailableDays(),
                            color: Colors.green,
                            thickness: 20)
                      ]
                  )
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ListDayOffPage(pool: pool);
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

