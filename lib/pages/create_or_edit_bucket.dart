
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:reuteuteu/hive_boxes.dart';
import 'package:reuteuteu/models/bucket.dart';
import 'package:reuteuteu/models/pool.dart';

class CreateOrEditBucketPage extends StatefulWidget {

  final bool isEdit;
  final Bucket? bucket;

  const CreateOrEditBucketPage({
    Key? key,
    required this.isEdit, this.bucket
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateOrEditDayOffPage();
  }

}

class _CreateOrEditDayOffPage  extends State<CreateOrEditBucketPage> {
  String title = "Create a new bucket";
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    if (widget.isEdit){
      nameController.text = widget.bucket!.name;
      title = "Edit bucket '${widget.bucket!.name}'";
    }else{
      nameController.text = _getDefaultBucketName();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
            padding: const EdgeInsets.all(40.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(key: _formKey,
                      child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Name',
                              ),
                              controller: nameController,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                if (!widget.isEdit && _isBucketNameExist(value)){
                                  return 'Bucket name exist already';
                                }
                                return null;
                              },
                            ),
                          ]
                      )
                  )
                ]
            )
        ),
        floatingActionButton: FloatingActionButton(
          // When the user presses the button, show an alert dialog containing
          // the text that the user has entered into the text field.
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (widget.isEdit){
                await _updateBucket(widget.bucket!);
              }else{
                await _persistBucket();
              }
              Navigator.pop(context);  // return to previous screen (main)
            }
          },
          child: const Icon(Icons.done),
          backgroundColor: Colors.green,
        )
    );

  }

  _persistBucket() async {
    Bucket newBucket = Bucket(nameController.text);
    final box = Boxes.getBuckets();
    box.add(newBucket);
    var newPoolBox = await Hive.openBox<Pool>('pools');
    newBucket.pools = HiveList(newPoolBox);
    newBucket.save();
  }

  String _getDefaultBucketName() {
    DateTime now = DateTime.now();
    DateTime nowPlusOneYear = DateTime(now.year + 1);
    String formatteYearNow = DateFormat('yyyy').format(now);
    String formatterNowPlusOneYear = DateFormat('yyyy').format(nowPlusOneYear);
    String finalDate = "$formatteYearNow/$formatterNowPlusOneYear";
    return finalDate;
  }

  bool _isBucketNameExist(String value) {
    final box = Boxes.getBuckets();
    for (Bucket existingBucket in box.values.toList().cast<Bucket>()){
      if (value == existingBucket.name){
        return true;
      }
    }
    return false;
  }

  _updateBucket(Bucket bucket) {
    bucket.name = nameController.text;
    bucket.save();
  }
}