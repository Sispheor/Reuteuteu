import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/create_or_edit_day_off.dart';
import 'package:reuteuteu/widgets/dialog_confirm_cancel.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: Text(widget.dayOff.getTotalTakenDays().toString(),
                      style: const TextStyle(color: Colors.white))),
              title: Text(widget.dayOff.name),
              subtitle: widget.dayOff.isHalfDay == true?
                        const Text("Half days"): null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => CreateOrEditDayOffPage(isEdit: true, pool: widget.pool, dayOff: widget.dayOff))
                    ).then((_) => setState(() { widget.callback();}));
                  }, icon: const Icon(Icons.edit)),
                  IconButton(onPressed: () async {
                    final action = await ConfirmCancelDialogs.yesAbortDialog(context, "Delete day off '${widget.dayOff.name}'?", 'Confirm');
                    if (action == DialogAction.confirmed) {
                      widget.dayOff.delete();
                      widget.callback();
                    }
                  }, icon: const Icon(Icons.delete)),
                ],
              ),
            ),
            // _TimelineTileStartEnd(dayOff: widget.dayOff)
            _TimeLine(dayOff: widget.dayOff)
          ],
        ),
      ),
    );
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
            barPointers: const [LinearBarPointer(value: 1, color: Colors.green)],
            markerPointers: [
              for (double i=0; i<2; i++)
                LinearWidgetPointer(
                  value: i,
                  child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(color: Colors.green,
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
                text: text,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
