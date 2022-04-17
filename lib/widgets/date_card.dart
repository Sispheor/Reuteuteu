
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCard extends StatelessWidget {

  final DateTime date;
  final DateFormat formatterDay = DateFormat('dd');
  final DateFormat formatterMonthYear = DateFormat('MMM yyyy');

  DateCard(this.date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.lightGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(formatterDay.format(date), style: const TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(height: 8.0),
                Text(formatterMonthYear.format(date)),
              ],
            ),
          ),
        ],
      ),
    );
  }

}