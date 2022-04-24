import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/create_or_edit_day_off.dart';
import 'package:reuteuteu/widgets/dialog_confirm_cancel.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
              leading: Container(
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green,
                      child: Text(widget.dayOff.getTotalTakenDays().toString(),
                          style: const TextStyle(color: Colors.white)))
              ),
              title: Text(widget.dayOff.name),
              // subtitle: widget.dayOff.isHalfDay? const Text(
              //   "Half day(s)",
              //   style: TextStyle(color: Colors.black),
              // ): null
              subtitle: _TimelineTileStartEnd(dayOff: widget.dayOff),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => CreateOrEditDayOffPage(isEdit: true, pool: widget.pool, callback: widget.callback, dayOff: widget.dayOff))
                    ).then((_) => setState(() {}));
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
          ],
        ),
      ),
    );
  }

}


class _TimelineTileStartEnd  extends StatelessWidget {

  const _TimelineTileStartEnd({
    Key? key,
    required this.dayOff,
  }) : super(key: key);

  final DayOff dayOff;

  @override
  Widget build(BuildContext context) {

    return Row(
        children: [
          Expanded(
              child: Column(
                  children: [
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.08,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        width: 30,
                        height: 30,
                        color: Colors.green,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: Icons.calendar_today,
                        ),
                      ),
                      beforeLineStyle: LineStyle(
                        color: _getColorIfHalfDay(dayOff),
                        thickness: 4,
                      ),
                      endChild: _Child(
                        text: DateFormat('dd MMMM yyyy').format(dayOff.dateStart),
                      ),
                    ),

                    if (dayOff.getTotalTakenDays() > 1)
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.08,
                        isLast: true,
                        indicatorStyle: IndicatorStyle(
                          width: 30,
                          height: 10,
                          color: Colors.green,
                          iconStyle: IconStyle(
                            color: Colors.white,
                            iconData: Icons.calendar_today,
                          ),
                        ),
                        beforeLineStyle: const LineStyle(
                          color: Colors.green,
                          thickness: 4,
                        ),
                        endChild: _Child(
                          text: DateFormat('dd MMMM yyyy').format(dayOff.dateEnd),
                        ),
                      ),
                  ]
              ))]
    );
  }

  _getColorIfHalfDay(DayOff isHalfDay) {
    if (dayOff.getTotalTakenDays() > 1){
      return Colors.green;
    }
    return Colors.white;
  }

}

class _Child extends StatelessWidget {
  const _Child({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {

    return Container(
        constraints: const BoxConstraints(
          minHeight: 50,
          maxHeight: 100,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // color: Colors.amberAccent,
          // constraints: const BoxConstraints(maxHeight: 40),
          child:
          Align(
            alignment: Alignment.centerLeft, // Align however you like (i.e .centerRight, centerLeft)
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        )
    );

  }
}
