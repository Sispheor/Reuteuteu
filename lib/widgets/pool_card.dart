import 'package:flutter/material.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/list_day_off.dart';
import 'package:reuteuteu/widgets/dialog_confirm_cancel.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PoolCardWidget extends StatelessWidget {

  PoolCardWidget({
    Key? key,
    required this.pool, required this.callback
  }) : super(key: key);

  final VoidCallback callback;
  Pool pool;

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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (_) => CreateOrEditDayOffPage(isEdit: true, pool: widget.pool, callback: widget.callback, dayOff: widget.dayOff))
                    // ).then((_) => setState(() {}));
                  }, icon: const Icon(Icons.edit)),
                  IconButton(onPressed: () async {
                    final action = await ConfirmCancelDialogs.yesAbortDialog(context, "Delete pool '${pool.name}'?", 'Confirm');
                    if (action == DialogAction.confirmed) {
                      pool.delete();
                      callback();
                    }
                  }, icon: const Icon(Icons.delete)),
                ],
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

