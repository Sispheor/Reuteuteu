import 'package:flutter/material.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/widgets/date_card.dart';

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
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DateCard(dayOff.dateStart),

                          if (dayOff.getTotalTakenDays() > 1)
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.green,
                              size: 30.0,
                            ),
                          if (dayOff.getTotalTakenDays() > 1)
                            DateCard(dayOff.dateEnd),
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
}
