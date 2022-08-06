import 'package:flutter/material.dart';
import 'package:sloth_day/models/bucket.dart';
import 'package:sloth_day/pages/homepage.dart';



class BucketCardWidget extends StatefulWidget {

  const BucketCardWidget({
    Key? key,
    required this.bucket
  }) : super(key: key);

  final Bucket bucket;

  @override
  State<BucketCardWidget> createState() => _BucketCardWidgetState();
}

class _BucketCardWidgetState extends State<BucketCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(widget.bucket.name),
              trailing: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_right,
                      color: Colors.white,
                      size: 30.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return HomePage(bucket: widget.bucket);
                      }),
                    );
                  }
              ),
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return HomePage(bucket: widget.bucket);
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
