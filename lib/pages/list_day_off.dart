import 'dart:developer';

import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sloth_day/hive_boxes.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';
import 'package:sloth_day/pages/create_or_edit_day_off.dart';
import 'package:sloth_day/widgets/consumption_gauge.dart';
import 'package:sloth_day/widgets/day_off_card.dart';

import '../models/bucket.dart';
import '../shared_preferences _manager.dart';
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

  FilterDaysOffDialogsAction? selectedFilter;

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
      _asyncLoadDayOffFilter();
    });
  }

  _asyncLoadDayOffFilter() async {
    var _selectedFilter = await SharedPrefManager.getDayOffFilter();
    setState(() {
      selectedFilter = _selectedFilter;
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
              if (action != FilterDaysOffDialogsAction.canceled){
                setState(() {
                  // log("Change filter to $action");
                  selectedFilter = action;
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
      body: Column(
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
                return FilteredDayOffList(bucket: widget.bucket, filter: selectedFilter,listDayOff: listDayOffs);
              },
            ),
          )
        ],
      ),

    );
  }
}
