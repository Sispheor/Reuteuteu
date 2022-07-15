import 'package:flutter/material.dart';
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
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return ListDayOffPage(bucket: widget.bucket, pool: widget.pool);
              }),
            ).then((_) => setState(() { widget.callback();}));
          },
          child: Column(
            children: [
              ListTile(
                title: Text(widget.pool.name, style: TextStyle(color: widget.pool.color, fontWeight: FontWeight.bold)),
                subtitle: Text("${removeDecimalZeroFormat(widget.pool.getTotalTakenDays())} taken / ${widget.pool.maxDays}",
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                trailing: PopupMenuButton(
                    onSelected: (value) {
                      _onMenuItemSelected(value as Options);
                    },
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => popupMenuItemEditDelete()
                ),

              ),
              Container(
                constraints: const BoxConstraints(
                    maxHeight: 80
                ),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          removeDecimalZeroFormat(widget.pool.getAvailableDays()),
                          style: TextStyle(color: widget.pool.color, fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "days available",
                          style: TextStyle(color: Colors.white.withOpacity(0.6)),
                        ),
                      ],
                    )
                ),
              ),
            ],
          ),
        )
    );
  }

  void _performRecursiveDeletion(Pool pool) {
    if (pool.dayOffList != null){
      for (DayOff dayOff in pool.dayOffList!.castHiveList()){
        dayOff.delete();
      }
    }
    pool.delete();
  }

  Future<void> _onMenuItemSelected(Options value) async {
    if (value == Options.edit) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => CreateOrEditPoolPage(isEdit: true, bucket: widget.bucket, pool: widget.pool))
      ).then((_) => setState(() {widget.callback();}));
    }
    if (value == Options.delete) {
      final action = await ConfirmCancelDialogs.yesAbortDialog(context, "Delete pool '${widget.pool.name}'?", 'Confirm');
      if (action == DialogAction.confirmed) {
        _performRecursiveDeletion(widget.pool);
        widget.callback();
      }
    }
  }
}
