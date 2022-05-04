import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';
import 'package:sloth_day/pages/create_or_edit_day_off.dart';
import 'package:sloth_day/widgets/dialog_confirm_cancel.dart';

enum Options { edit, delete }

class DayOffCardWidget extends StatefulWidget {

  final DayOff dayOff;
  final VoidCallback callback;
  final Pool pool;

  const DayOffCardWidget({
    Key? key,
    required this.dayOff, required this.pool, required this.callback
  }) : super(key: key);


  @override
  State<DayOffCardWidget> createState() => _DayOffCardWidgetState();
}

class _DayOffCardWidgetState extends State<DayOffCardWidget> {

  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(widget.dayOff.name, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Text(widget.dayOff.getTotalTakenDays().toString().replaceAll(regex, ''),
                      style: const TextStyle(color: Colors.white))),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.dayOff.isHalfDay)
                  const Text('Half days', style: TextStyle(fontSize: 12)),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child:RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Icon(Icons.calendar_today, size: 15, color: Colors.green),
                            ),
                            TextSpan(
                              text: " " + DateFormat('dd MMMM yyyy').format(widget.dayOff.dateStart),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )),
                  if (widget.dayOff.getTotalTakenDays() > 1)
                  const Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Icon(Icons.arrow_drop_down, size: 15, color: Colors.green)
                  ),
                  if (widget.dayOff.getTotalTakenDays() > 1)
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child:RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Icon(Icons.calendar_today, size: 15, color: Colors.green),
                            ),
                            TextSpan(
                              text: " " + DateFormat('dd MMMM yyyy').format(widget.dayOff.dateEnd),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ))
                ],
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
          ],
        ),
      ),
    );
  }

  Future<void> _onMenuItemSelected(Options value) async {
    if (value == Options.edit) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => CreateOrEditDayOffPage(isEdit: true, pool: widget.pool, dayOff: widget.dayOff))
      ).then((_) => setState(() { widget.callback();}));
    }
    if (value == Options.delete) {
      final action = await ConfirmCancelDialogs.yesAbortDialog(context, "Delete pool '${widget.pool.name}'?", 'Confirm');
      if (action == DialogAction.confirmed) {
        widget.dayOff.delete();
        widget.callback();
      }
    }
  }

}
