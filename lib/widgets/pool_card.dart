import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:sloth_day/models/bucket.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';
import 'package:sloth_day/pages/create_or_edit_pool.dart';
import 'package:sloth_day/pages/list_day_off.dart';
import 'package:sloth_day/utils/widget_utils.dart';
import 'package:sloth_day/widgets/dialog_confirm_cancel.dart';

import 'edit_delete_menu_item.dart';


class PoolCardWidget extends StatefulWidget {

  const PoolCardWidget({
    Key? key,
    required this.pool, required this.bucket, required this.callback
  }) : super(key: key);

  final VoidCallback callback;
  final Pool pool;
  final Bucket bucket;

  @override
  State<PoolCardWidget> createState() => _PoolCardWidgetState();
}

class _PoolCardWidgetState extends State<PoolCardWidget> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: NordColors.$3.withOpacity(0.6),
      child:  ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return ListDayOffPage(bucket: widget.bucket, pool: widget.pool);
              }),
            ).then((_) => setState(() { widget.callback();}));
          },
          leading: Text(
            removeDecimalZeroFormat(widget.pool.getAvailableDays()),
            style: TextStyle(color: widget.pool.color, fontSize: 50, fontWeight: FontWeight.bold),
          ),
          title: Text(widget.pool.name, style: TextStyle(color: widget.pool.color, fontWeight: FontWeight.bold)),
          subtitle: Text("${removeDecimalZeroFormat(widget.pool.getTotalTakenDays())} taken / ${widget.pool.maxDays}",
            style: const TextStyle(color: NordColors.$6),
          ),
          trailing: IconButton(
              icon: const Icon(Icons.keyboard_arrow_right,
                  color: Colors.white,
                  size: 30.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ListDayOffPage(bucket: widget.bucket, pool: widget.pool);
                  }),
                ).then((_) => setState(() { widget.callback();}));
              }
          ),

      ),
    );
  }
}
