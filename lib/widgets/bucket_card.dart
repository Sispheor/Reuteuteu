import 'package:flutter/material.dart';
import 'package:reuteuteu/models/bucket.dart';
import 'package:reuteuteu/pages/list_pool.dart';

class BucketCardWidget extends StatelessWidget {

  const BucketCardWidget({
    Key? key,
    required this.bucket
  }) : super(key: key);

  final Bucket bucket;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(bucket.name),
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ListPoolPage(bucket: bucket);
                    }),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
