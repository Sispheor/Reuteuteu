import 'package:flutter/material.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/create_or_edit_day_off.dart';
import 'package:reuteuteu/widgets/date_card.dart';

class DayOffCardWidget extends StatefulWidget {

  DayOff dayOff;
  final VoidCallback callback;
  final Pool pool;

  DayOffCardWidget({
    Key? key,
    required this.dayOff, required this.callback, required this.pool
  }) : super(key: key);


  @override
  State<DayOffCardWidget> createState() => _DayOffCardWidgetState();
}

class _DayOffCardWidgetState extends State<DayOffCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(widget.dayOff.getTotalTakenDays().toString(),
                      style: const TextStyle(color: Colors.white))),
              title: Text(widget.dayOff.name),
              subtitle: widget.dayOff.isHalfDay? const Text(
                "Half day(s)",
                style: TextStyle(color: Colors.black),
              ): null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => CreateOrEditDayOffPage(isEdit: true, pool: widget.pool, callback: widget.callback, dayOff: widget.dayOff))
                    ).then((_) => setState(() {}));
                  }, icon: const Icon(Icons.edit)),
                  IconButton(onPressed: () {
                    _showConfirmDeleteDialog(context, widget.dayOff);
                  }, icon: const Icon(Icons.delete)),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DateCard(widget.dayOff.dateStart),

                          if (widget.dayOff.getTotalTakenDays() >= 1)
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.green,
                              size: 30.0,
                            ),
                          if (widget.dayOff.getTotalTakenDays() >= 1)
                            DateCard(widget.dayOff.dateEnd),
                        ],
                      ),

                    ]
                )
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmDeleteDialog(BuildContext context, DayOff dayOffToDelete) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm deletion'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Delete the taken day '${dayOffToDelete.name}'"),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Confirm', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                widget.dayOff.delete();
                widget.callback();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
