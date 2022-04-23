import 'package:flutter/material.dart';
import 'package:reuteuteu/models/bucket.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/widgets/ConsumptionGauge.dart';
import 'package:reuteuteu/widgets/pool_card.dart';


class ListPoolPage extends StatefulWidget {

  final Bucket bucket;

  const ListPoolPage({Key? key,
    required this.bucket}) : super(key: key);

  @override
  _ListPoolPageState createState() => _ListPoolPageState();
}

class _ListPoolPageState extends State<ListPoolPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bucket ${widget.bucket.name}"),
      ),
      body: Column(
        children: [
          Card(
            // margin: const EdgeInsets.all(10.0),
              child: Container(
                  height: 150,
                  // child: _buildGauge(currentPoolUpdated!)
                  child: ConsumptionGauge(max: widget.bucket.getPoolMaxDays(), available: widget.bucket.getAvailable())
              )
          ),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: widget.bucket.pools!.castHiveList().cast<Pool>().map((pool) => PoolCardWidget(pool: pool)).toList(),
          )
        ],
      ),

    );
  }
}