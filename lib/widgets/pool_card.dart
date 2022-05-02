import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:sloth_day/models/bucket.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';
import 'package:sloth_day/pages/create_or_edit_pool.dart';
import 'package:sloth_day/pages/list_day_off.dart';
import 'package:sloth_day/widgets/dialog_confirm_cancel.dart';

enum Options { edit, delete }

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
            ).then((_) => setState(() { widget.callback();}));
          },
          child: Column(
            children: [
              ListTile(
                title: Text(widget.pool.name, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                subtitle: Text("${widget.pool.getTotalTakenDays().toString().replaceAll(regex, '')} taken / ${widget.pool.maxDays}",
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                trailing: PopupMenuButton(
                    onSelected: (value) {
                      _onMenuItemSelected(value as Options);
                    },
                    icon: const Icon(Icons.more_vert),
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
                          style: TextStyle(color: Colors.green, fontSize: 50, fontWeight: FontWeight.bold),
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
