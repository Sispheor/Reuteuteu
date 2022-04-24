import 'package:flutter/material.dart';
import 'package:reuteuteu/models/bucket.dart';
import 'package:reuteuteu/pages/create_or_edit_bucket.dart';
import 'package:reuteuteu/pages/list_pool.dart';
import 'package:reuteuteu/widgets/dialog_confirm_cancel.dart';

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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => CreateOrEditBucketPage(isEdit: true, bucket: widget.bucket))
                    ).then((_) => setState(() {}));
                  }, icon: const Icon(Icons.edit)),
                  IconButton(onPressed: () async {
                    final action = await ConfirmCancelDialogs.yesAbortDialog(context, "Delete bucket '${widget.bucket.name}'?", 'Confirm');
                    if (action == DialogAction.confirmed) {
                      widget.bucket.delete();
                      // widget.callback();
                    }
                  }, icon: const Icon(Icons.delete)),
                ],
              ),
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ListPoolPage(bucket: widget.bucket);
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
