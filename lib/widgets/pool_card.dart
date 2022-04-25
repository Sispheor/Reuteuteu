import 'package:flutter/material.dart';
import 'package:reuteuteu/models/bucket.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/create_or_edit_pool.dart';
import 'package:reuteuteu/pages/list_day_off.dart';
import 'package:reuteuteu/widgets/dialog_confirm_cancel.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PoolCardWidget extends StatefulWidget {

  PoolCardWidget({
    Key? key,
    required this.pool, required this.callback, required this.bucket
  }) : super(key: key);

  final VoidCallback callback;
  Pool pool;
  Bucket bucket;

  @override
  State<PoolCardWidget> createState() => _PoolCardWidgetState();
}

class _PoolCardWidgetState extends State<PoolCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(widget.pool.name),
              subtitle: Container(
                  height: 100,
                  child: SfLinearGauge(
                      interval: widget.pool.maxDays,
                      minimum: 0,
                      maximum: widget.pool.maxDays,
                      markerPointers: [
                        LinearWidgetPointer(
                          position: LinearElementPosition.outside,
                          value: widget.pool.getAvailableDays(),
                          offset: 15,
                          child: Text(widget.pool.getAvailableDays().toString()),
                        ),
                      ],
                      barPointers: [
                        LinearBarPointer(value: widget.pool.getAvailableDays(),
                            color: Colors.green,
                            thickness: 20)
                      ]
                  )
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => CreateOrEditPoolPage(isEdit: true, bucket: widget.bucket, pool: widget.pool, callback: widget.callback))
                    ).then((_) => setState(() {}));
                  }, icon: const Icon(Icons.edit)),
                  IconButton(onPressed: () async {
                    final action = await ConfirmCancelDialogs.yesAbortDialog(context, "Delete pool '${widget.pool.name}'?", 'Confirm');
                    if (action == DialogAction.confirmed) {
                      widget.pool.delete();
                      widget.callback();
                    }
                  }, icon: const Icon(Icons.delete)),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ListDayOffPage(pool: widget.pool);
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

