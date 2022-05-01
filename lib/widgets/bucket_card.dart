import 'package:flutter/material.dart';
import 'package:sloth_day/models/bucket.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';
import 'package:sloth_day/pages/create_or_edit_bucket.dart';
import 'package:sloth_day/pages/homepage.dart';
import 'package:sloth_day/widgets/dialog_confirm_cancel.dart';

enum Options { edit, delete }

class BucketCardWidget extends StatefulWidget {

  BucketCardWidget({
    Key? key,
    required this.bucket
  }) : super(key: key);

  Bucket bucket;

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
              trailing: PopupMenuButton(
                  onSelected: (value) {
                    _onMenuItemSelected(value as Options);
                  },
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: Options.edit,
                      child:  Row(
                        children: const [
                          Icon(Icons.edit),
                          Text("Edit"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: Options.delete,
                      child:  Row(
                        children: const [
                          Icon(Icons.delete),
                          Text("Delete"),
                        ],
                      ),
                    )
                  ]
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

  Future<void> _onMenuItemSelected(Options value) async {
    if (value == Options.edit) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => CreateOrEditBucketPage(isEdit: true, bucket: widget.bucket))
      ).then((_) => setState(() {}));
    }
    if (value == Options.delete) {
      final action = await ConfirmCancelDialogs.yesAbortDialog(context, "Delete bucket '${widget.bucket.name}'?", 'Confirm');
      if (action == DialogAction.confirmed) {
        _performRecursiveDeletion(widget.bucket);
      }
    }
  }

  void _performRecursiveDeletion(Bucket bucket) {
    if (bucket.pools != null){
      for (Pool pool in bucket.pools!.castHiveList()){
        if (pool.dayOffList != null){
          for (DayOff dayOff in pool.dayOffList!.castHiveList()){
            dayOff.delete();
          }
        }
        pool.delete();
      }
      bucket.delete();
    }
  }
}
