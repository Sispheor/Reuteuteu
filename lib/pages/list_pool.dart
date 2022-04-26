import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reuteuteu/hive_boxes.dart';
import 'package:reuteuteu/models/bucket.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/create_or_edit_pool.dart';
import 'package:reuteuteu/widgets/consumption_gauge.dart';
import 'package:reuteuteu/widgets/pool_card.dart';


class ListPoolPage extends StatefulWidget {

  final Bucket bucket;

  const ListPoolPage({Key? key,
    required this.bucket
  }) : super(key: key);

  @override
  _ListPoolPageState createState() => _ListPoolPageState();
}

class _ListPoolPageState extends State<ListPoolPage>{

  List<Pool> listPools = [];
  late Bucket? currentBucketUpdated = Boxes.getBuckets().get(widget.bucket.key);

  void getPools() {
    currentBucketUpdated = Boxes.getBuckets().get(widget.bucket.key);
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CreateOrEditPoolPage(isEdit: false, bucket: widget.bucket, callback: getPools)));
            },
          )
        ],
      ),
      body: Column(
            children: [
              if (listPools.isNotEmpty)
                Card(
                  // margin: const EdgeInsets.all(10.0),
                    child: Container(
                        height: 150,
                        child: ConsumptionGauge(max: currentBucketUpdated!.getPoolMaxDays(), available: currentBucketUpdated!.getAvailable())
                    )
                ),
              Expanded(
                child: ValueListenableBuilder<Box<Pool>>(
                  valueListenable: Boxes.getPools().listenable(),
                  builder: (context, box, _) {
                    if (listPools.isEmpty) {
                      return const Center(
                        child: Text(
                          'No pool yet',
                          style: TextStyle(fontSize: 24),
                        ),
                      );
                    }else{
                      return  ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: listPools.map((pool) => PoolCardWidget(bucket: widget.bucket, pool: pool, callback: getPools)).toList(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
    );
  }

}