import 'dart:developer';

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

  callback(){
    setState(() {
      // this debug force the update of the widget
      log("New pool length: ${widget.bucket.pools?.length}");
    });
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
                  MaterialPageRoute(builder: (_) => CreateOrEditPoolPage(isEdit: false, bucket: widget.bucket))).then((_) => setState(() {}));
            },
          )
        ],
      ),
      body: Column(
            children: [
              if (widget.bucket.pools!.isNotEmpty)
              Card(
                  child: SizedBox(
                      height: 150,
                      child: ConsumptionGauge(max: widget.bucket.getPoolMaxDays(), available: widget.bucket.getAvailable())
                  )
              ),
              Expanded(
                child: ValueListenableBuilder<Box<Pool>>(
                  valueListenable: Boxes.getPools().listenable(),
                  builder: (context, box, _) {
                    final pools = box.values.where((element) => widget.bucket.pools!.contains(element));
                    if (pools.isEmpty) {
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
                        children: pools.cast<Pool>().map((pool) => PoolCardWidget(bucket: widget.bucket, pool: pool, callback: callback)).toList(),
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