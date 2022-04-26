

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reuteuteu/hive_boxes.dart';
import 'package:reuteuteu/models/bucket.dart';
import 'package:reuteuteu/models/pool.dart';

class CreateOrEditPoolPage extends StatefulWidget {

  final bool isEdit;
  final VoidCallback callback;
  final Bucket bucket;
  final Pool? pool;

  CreateOrEditPoolPage({
    Key? key,
    required this.isEdit, required this.bucket, this.pool, required this.callback
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateOrEditPoolPage();
  }

}

class _CreateOrEditPoolPage extends State<CreateOrEditPoolPage> {

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final maxDayController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    String title = "Create a pool of day off";

    if (widget.isEdit){
      title = "Edit pool '${widget.pool!.name}'";
      nameController.text = widget.pool!.name;
      maxDayController.text = widget.pool!.maxDays.toStringAsFixed(0);
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
                                  labelText: 'Name'
                              ),
                              controller: nameController,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                if (!widget.isEdit && _isPoolNameExist(value)){
                                  return 'Bucket name exist already';
                                }
                                return null;
                              },
                            ),
                            TextField(
                              controller: maxDayController,
                              decoration: const InputDecoration(labelText: "Number of day"),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered
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
                await _updatePool(widget.pool!);
              }else{
                await _persistPool();
              }
              widget.callback();
              Navigator.pop(context);  // return to previous screen (main)
            }
          },
          child: const Icon(Icons.done),
          backgroundColor: Colors.green,
        )
    );
  }


  Future<void> _persistPool() async {

    Pool newPool = Pool(
        nameController.text,
        double.parse(maxDayController.text));
    final box = Boxes.getPools();
    box.add(newPool);
    widget.bucket.pools!.add(newPool);
    widget.bucket.save();
    // widget.callback();
  }

  bool _isPoolNameExist(String value) {
    final box = Boxes.getPools();
    for (Pool existingPool in box.values.toList().cast<Pool>()){
      if (value == existingPool.name){
        return true;
      }
    }
    return false;
  }

  _updatePool(Pool poolToUpdate) {
    poolToUpdate.name = nameController.text;
    poolToUpdate.maxDays = double.parse(maxDayController.text);
    poolToUpdate.save();
  }

}
