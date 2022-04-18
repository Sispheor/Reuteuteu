

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reuteuteu/hive_boxes.dart';
import 'package:reuteuteu/models/day_off.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/utils/widget_utils.dart';

class CreateOrEditDayOffPage extends StatefulWidget {

  final bool isEdit;
  final Pool pool;
  final VoidCallback callback;

  const CreateOrEditDayOffPage({
    Key? key,
    required this.isEdit, required this.pool, required this.callback
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateOrEditDayOffPage();
  }

}

class _CreateOrEditDayOffPage extends State<CreateOrEditDayOffPage> {

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dateRangeController = TextEditingController();
  bool isHalfDay = false;
  DateTime? dayOffDateStart;
  DateTime? dayOffDateEnd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Take a day in '${widget.pool.name}'"),
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
                                return null;
                              },
                            ),
                            TextFormField(
                                decoration: const InputDecoration(labelText: "Date range"),
                                focusNode: AlwaysDisabledFocusNode(),
                                controller: dateRangeController,
                                onTap: () {
                                  _datePicker(context);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select a date";
                                  }
                                }
                            ),
                            Row(
                              children: [
                                Material(
                                  child: Checkbox(
                                    value: isHalfDay,
                                    onChanged: (value) {
                                      setState(() {
                                        isHalfDay = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const Text(
                                  'Half day',
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
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
              // TODO check no date overlap (except if both are half days)
              await _persistDayOff();
              Navigator.pop(context);  // return to previous screen (main)
            }
          },
          child: const Icon(Icons.done),
          backgroundColor: Colors.green,
        )
    );
  }

  Future<void> _datePicker(BuildContext context) async {
    final initialDateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(Duration(hours: 24))
    );
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 3),
    );
    print(picked);
    String dateStart = DateFormat('yyyy-MM-dd').format(picked!.start);
    String dateEnd = DateFormat('yyyy-MM-dd').format(picked.end);
    dateRangeController.text = "$dateStart → $dateEnd";
    dayOffDateStart = picked.start;
    dayOffDateEnd = picked.end;
  }

  Future<void> _persistDayOff() async {

    DayOff newDayOff = DayOff(
        nameController.text,
        dayOffDateStart!,
        dayOffDateEnd!,
        isHalfDay);
    final box = Boxes.getDayOffs();
    box.add(newDayOff);
    widget.pool.dayOffList!.add(newDayOff);
    widget.pool.save();
    widget.callback();
    // // debug
    // // List<DayOff> result = await dao.findAllDayOff();
    // // debugPrint('result: $result');
    // // for (var res in result) {
    // //   debugPrint('res: $res');
    // // }
  }

}
