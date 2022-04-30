import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:intl/intl.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/create_or_edit_day_off.dart';
import 'package:reuteuteu/widgets/dialog_confirm_cancel.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
              title: Text(widget.dayOff.name, style: TextStyle(color: NordColors.frost.lighter, fontWeight: FontWeight.bold)),
              subtitle: widget.dayOff.isHalfDay == true?
                        const Text("Half days"): null,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    radius: 30,
                    backgroundColor: NordColors.frost.lighter,
                    child: Text(widget.dayOff.getTotalTakenDays().toString().replaceAll(regex, ''),
                        style: const TextStyle(color: Colors.white))),
                _TimeLine(dayOff: widget.dayOff)
              ],
            )
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


class _TimeLine extends StatelessWidget {

  const _TimeLine({
    Key? key,
    required this.dayOff,
  }) : super(key: key);

  final DayOff dayOff;

  @override
  Widget build(BuildContext context){

    return Container(
        constraints: const BoxConstraints(
            maxHeight: 100
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SfLinearGauge(
            showLabels: false,
            showTicks: false,
            orientation: LinearGaugeOrientation.vertical,
            minimum: 0,
            maximum: 1,
            interval: 1,
            barPointers: [LinearBarPointer(value: 1, color: NordColors.frost.lighter)],
            markerPointers: [
              for (double i=0; i<2; i++)
                LinearWidgetPointer(
                  value: i,
                  child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(color: NordColors.frost.lighter,
                          shape: BoxShape.circle)
                  ),
                ),
              _getPointer(1, DateFormat('dd MMMM yyyy').format(dayOff.dateStart)),
              _getPointer(0, DateFormat('dd MMMM yyyy').format(dayOff.dateEnd))
            ],
          ),
        )
    );
  }

  _getPointer(double position, String text) {
    return LinearWidgetPointer(
      value: position,
      position: LinearElementPosition.inside,
      dragBehavior: LinearMarkerDragBehavior.constrained,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        // color: Colors.amberAccent,
        // constraints: const BoxConstraints(maxHeight: 40),
        child: RichText(
          text: TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(Icons.calendar_today, size: 15),
              ),
              TextSpan(
                text: " $text",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
