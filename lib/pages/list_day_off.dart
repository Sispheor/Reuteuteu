import 'dart:developer';

import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sloth_day/hive_boxes.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';
import 'package:sloth_day/pages/create_or_edit_day_off.dart';
import 'package:sloth_day/widgets/consumption_gauge.dart';

import '../models/bucket.dart';
import '../utils/shared_preferences _manager.dart';
import '../widgets/dialog_filter_days_off.dart';
import '../widgets/filtered_day_off_list.dart';


class ListDayOffPage extends StatefulWidget {

  final Bucket bucket;
  final Pool pool;

  const ListDayOffPage({Key? key,
    required this.bucket, required this.pool }) : super(key: key);

  @override
  _ListDayOffPageState createState() => _ListDayOffPageState();
}

class _ListDayOffPageState extends State<ListDayOffPage>{

  DayOffDateFilter? selectedStartEndDayOffFilter;
  FilterDaysOffDialogsAllPastFuture? selectedPastFutureDayOffFilter;

  callback(){
    setState(() {
      // this debug force the update of the widget
      log("New day off list length: ${widget.pool.dayOffList?.length}");
    });
  }

  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncLoadDayOffFilters();
    });
  }

  _asyncLoadDayOffFilters() async {
    var _selectedStartEndFilter = await SharedPrefManager.getStartEndDayOffFilter();
    var _selectedPastFutureFilter = await SharedPrefManager.getPastFutureDayOffFilter();
    setState(() {
      selectedStartEndDayOffFilter = _selectedStartEndFilter;
      selectedPastFutureDayOffFilter = _selectedPastFutureFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: NordColors.polarNight.darkest,
          title: Text("Pool ${widget.pool.name}"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () async {
                final action = await FilterDaysOffDialogs.selectFilterDialog(context);
                if (action != FilterDaysOffAction.canceled){
                  setState(() {
                    _asyncLoadDayOffFilters();
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CreateOrEditDayOffPage(isEdit: false, pool: widget.pool))).then((_) => setState(() {}));
              },
            )
          ],
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/sloth6.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter),
          ),
          child:


          Column(
            children: [
              if (widget.pool.dayOffList != null && widget.pool.dayOffList!.isNotEmpty)
                Card(
                    child: SizedBox(
                        height: 150,
                        child: ConsumptionGauge(max: widget.pool.maxDays, available: widget.pool.getAvailableDays())
                    )
                ),
              Expanded(
                child: ValueListenableBuilder<Box<DayOff>>(
                  valueListenable: Boxes.getDayOffs().listenable(),
                  builder: (context, box, _) {
                    final listDayOffs = box.values.where((element) => widget.pool.dayOffList!.contains(element));
                    return FilteredDayOffList(bucket: widget.bucket,
                        startEndDayOffFilter: selectedStartEndDayOffFilter,
                        pastFutureDayOffFilter: selectedPastFutureDayOffFilter,
                        listDayOff: listDayOffs,
                    callback: callback);
                  },
                ),
              )
            ],
          ),

        ));
  }
}
