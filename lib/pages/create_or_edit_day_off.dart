

import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:intl/intl.dart';
import 'package:sloth_day/hive_boxes.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';
import 'package:sloth_day/utils/widget_utils.dart';

class CreateOrEditDayOffPage extends StatefulWidget {

  final bool isEdit;
  final Pool pool;
  final DayOff? dayOff;

  const CreateOrEditDayOffPage({
    Key? key,
    required this.isEdit, required this.pool, this.dayOff
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
  bool firstTimeEdit = true;  // prevent checkbox setstate from resetting already done change in text box

  @override
  Widget build(BuildContext context) {

    String title = "Take a day in '${widget.pool.name}'";

    if (widget.isEdit) {
      if (firstTimeEdit){
        nameController.text = widget.dayOff!.name;
        isHalfDay = widget.dayOff!.isHalfDay;
        dayOffDateStart = widget.dayOff!.dateStart;
        dayOffDateEnd = widget.dayOff!.dateEnd;
        String dateStart = DateFormat('yyyy-MM-dd').format(widget.dayOff!.dateStart);
        String dateEnd = DateFormat('yyyy-MM-dd').format(widget.dayOff!.dateEnd);
        dateRangeController.text = "$dateStart → $dateEnd";
        title = "Edit day off '${widget.dayOff!.name}'";
        firstTimeEdit = false;
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: NordColors.polarNight.darkest,
          title: Text(title),
        ),
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/sloth4.png"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,),
            ),
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
                                  return null;
                                }
                            ),
                            Row(
                              children: [
                                Material(
                                  child: Checkbox(
                                    value: isHalfDay,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        isHalfDay = newValue!;
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
              if (widget.isEdit){
                await _updateDayOff(widget.dayOff!);
              }else{
                await _persistDayOff();
              }
              Navigator.pop(context);  // return to previous screen (main)
            }
          },
          child: const Icon(Icons.done),
          backgroundColor: Colors.green,
        )
    );
  }

  Future<void> _datePicker(BuildContext context) async {
    var initialDateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(hours: 24))
    );
    if (widget.isEdit){
      initialDateRange = DateTimeRange(
          start: widget.dayOff!.dateStart,
          end:widget.dayOff!.dateEnd
      );
    }
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 3),
    );
    if (picked != null){
      String dateStart = DateFormat('yyyy-MM-dd').format(picked.start);
      String dateEnd = DateFormat('yyyy-MM-dd').format(picked.end);
      dateRangeController.text = "$dateStart → $dateEnd";
      dayOffDateStart = picked.start;
      dayOffDateEnd = picked.end;
    }

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
  }

  _updateDayOff(DayOff dayOffToUpdate) {
    dayOffToUpdate.name = nameController.text;
    dayOffToUpdate.dateStart = dayOffDateStart!;
    dayOffToUpdate.dateEnd = dayOffDateEnd!;
    dayOffToUpdate.isHalfDay = isHalfDay;
    dayOffToUpdate.save();
  }

}
