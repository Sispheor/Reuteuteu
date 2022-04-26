import 'package:flutter/material.dart';
import 'package:reuteuteu/models/bucket.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/create_or_edit_pool.dart';
import 'package:reuteuteu/pages/list_day_off.dart';
import 'package:reuteuteu/widgets/dialog_confirm_cancel.dart';

enum Options { edit, delete }

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

  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return ListDayOffPage(pool: widget.pool);
              }),
            );
          },
          child: Column(
            children: [
              ListTile(
                // leading: Icon(Icons.arrow_drop_down_circle),
                title: Text(widget.pool.name),
                subtitle: Text("${widget.pool.getTotalTakenDays()} taken / ${widget.pool.maxDays}",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
                trailing: PopupMenuButton(
                    onSelected: (value) {
                      _onMenuItemSelected(value as Options);
                    },
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: Options.edit,
                        child:  Row(
                          children: const [
                            Icon(Icons.edit),
                            Text("Edit"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: Options.delete,
                        child:  Row(
                          children: const [
                            Icon(Icons.delete),
                            Text("Delete"),
                          ],
                        ),
                      )
                    ]
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
                          widget.pool.getAvailableDays().toString().replaceAll(regex, ''),
                          style: const TextStyle(color: Colors.green, fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "available",
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
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
          MaterialPageRoute(builder: (_) => CreateOrEditPoolPage(isEdit: true, bucket: widget.bucket, pool: widget.pool, callback: widget.callback))
      ).then((_) => setState(() {}));
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
