import 'package:flutter/material.dart';
import 'package:reuteuteu/models/day_off.dart';

class DayOffCardWidget extends StatelessWidget {

  const DayOffCardWidget({
    Key? key,
    required this.dayOff
  }) : super(key: key);

  final DayOff dayOff;

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
                  child: Text(dayOff.getTotalTakenDays().toString(),
                      style: const TextStyle(color: Colors.white))),
              title: Text(dayOff.name),
              subtitle: dayOff.isHalfDay? const Text(
                "Half day(s)",
                style: TextStyle(color: Colors.black),
              ): null,
            ),
          ],
        ),
      ),
    );
  }
}
