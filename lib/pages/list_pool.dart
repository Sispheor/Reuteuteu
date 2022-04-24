import 'package:flutter/material.dart';
import 'package:reuteuteu/hive_boxes.dart';
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

  List<Pool> listPools = [];
  late Bucket? currentBucketUpdated = Boxes.getBuckets().getAt(widget.bucket.key);

  void getPools() {
    currentBucketUpdated = Boxes.getBuckets().getAt(widget.bucket.key);
    currentBucketUpdated!.save();
    if (currentBucketUpdated != null && currentBucketUpdated!.pools != null){
      if (currentBucketUpdated!.pools!.isNotEmpty){
        setState(() {
          listPools = currentBucketUpdated!.pools!.castHiveList().cast<Pool>();
        });
      }else{
        setState(() {
          listPools = [];
        });
      }
    }
  }

  @override
  void initState() {
    getPools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bucket ${widget.bucket.name}"),
      ),
      body: Column(
        children: [
          if (listPools.isNotEmpty)
          Card(
            // margin: const EdgeInsets.all(10.0),
              child: Container(
                  height: 150,
                  // child: _buildGauge(currentPoolUpdated!)
                  child: ConsumptionGauge(max: currentBucketUpdated!.getPoolMaxDays(), available: currentBucketUpdated!.getAvailable())
              )
          ),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: listPools.map((pool) => PoolCardWidget(pool: pool, callback: getPools)).toList(),
          )
        ],
      ),

    );
  }


}