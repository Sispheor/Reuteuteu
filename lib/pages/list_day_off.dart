import 'package:flutter/material.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/widgets/day_off_card.dart';
import 'package:reuteuteu/widgets/pool_card.dart';


class ListDayOffPage extends StatefulWidget {

  final Pool pool;

  const ListDayOffPage({Key? key,
    required this.pool}) : super(key: key);

  @override
  _ListDayOffPageState createState() => _ListDayOffPageState();
}

class _ListDayOffPageState extends State<ListDayOffPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pool ${widget.pool.name}"),
      ),
      body: Column(
        children: [
          Card(
            child: Column(
                children: [
                  ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(widget.pool.maxDays.toString(),
                                style: const TextStyle(color: Colors.white))
                        ),
                      ),
                      title: const Text('Total', style: TextStyle(color: Colors.black))
                  ),
                  ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(widget.pool.getTotalTakenDays().toString(),
                                style: const TextStyle(color: Colors.white))
                        ),
                      ),
                      title: const Text('Consumed', style: TextStyle(color: Colors.black))
                  ),
                  ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(widget.pool.getAvailableDays().toString(),
                                style: const TextStyle(color: Colors.white))
                        ),
                      ),
                      title: const Text('Available', style: TextStyle(color: Colors.black))
                  ),
                ],
            ),
          ),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: widget.pool.dayOffList!.castHiveList().cast<DayOff>().map((dayOff) => DayOffCardWidget(dayOff: dayOff)).toList(),
          )
        ],
      ),

    );
  }
}