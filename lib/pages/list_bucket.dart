import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:reuteuteu/hive_boxes.dart';
import 'package:reuteuteu/pages/create_or_edit_bucket.dart';
import 'package:reuteuteu/widgets/bucket_card.dart';

import '../models/bucket.dart';

class ListBucketPage extends StatefulWidget {
  const ListBucketPage({Key? key}) : super(key: key);

  @override
  _ListBucketPageState createState() => _ListBucketPageState();
}

class _ListBucketPageState extends State<ListBucketPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: NordColors.polarNight.darkest,
          title: const Text("Sloth"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CreateOrEditBucketPage(isEdit: false)));
              },
            )
          ],
        ),
        body: ValueListenableBuilder<Box<Bucket>>(
          valueListenable: Boxes.getBuckets().listenable(),
          builder: (context, box, _) {
            final buckets = box.values.toList().cast<Bucket>();
            if (buckets.isEmpty) {
              return const Center(
                child: Text(
                  'No buckets yet',
                  style: TextStyle(fontSize: 24),
                ),
              );
            }else{
              return ListView(
                children: buckets.map((bucket) => BucketCardWidget(bucket: bucket)).toList(),
              );
            }

          },
        ),
      ),
    );
  }
}


