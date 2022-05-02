import 'package:flutter/material.dart';
import 'package:sloth_day/hive_boxes.dart';
import 'package:sloth_day/models/bucket.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';
import 'package:sloth_day/pages/create_or_edit_day_off.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class CalendarPage extends StatefulWidget{

  final Bucket bucket;

  const CalendarPage({Key? key, required this.bucket }) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();

}

class _CalendarPageState extends State<CalendarPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            constraints: BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  scale: 6,
                  alignment: Alignment.bottomCenter,
                image: AssetImage("assets/images/sloth1.png"),
                ),
            ),
            child: SfCalendar(
              view: CalendarView.month,
              firstDayOfWeek: 1, // Monday
              showDatePickerButton: true,
              monthViewSettings: const MonthViewSettings(showAgenda: true,
                agendaItemHeight: 50,
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
              dataSource: DayOffDataSource(_getDataSource()),
              onTap: calendarTapped,
            )
        ));

    return  SfCalendar(
      view: CalendarView.month,
      firstDayOfWeek: 1, // Monday
      showDatePickerButton: true,
      monthViewSettings: const MonthViewSettings(showAgenda: true,
        agendaItemHeight: 50,
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
      dataSource: DayOffDataSource(_getDataSource()),
      onTap: calendarTapped,
    );
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      DayOff selectedDayOff = details.appointments![0];
      print(selectedDayOff);
      Pool pool = _getPoolOfDayOff(selectedDayOff);
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => CreateOrEditDayOffPage(isEdit: true, pool: pool, dayOff: selectedDayOff))
      ).then((_) => setState(() { }));
    }

  }

  List<DayOff> _getDataSource() {
    return Boxes.getDayOffs().values.where((dayOff) => isDayOffPartOfTheCurrentBucket(dayOff)).toList();
  }

  _getPoolOfDayOff(DayOff dayOff) {
    for (Pool pool in widget.bucket.pools!.castHiveList().cast<Pool>()){
      if (pool.dayOffList!.contains(dayOff)){
        return pool;
      }
    }
  }

  bool isDayOffPartOfTheCurrentBucket(DayOff dayOff) {
    for (Pool pool in widget.bucket.pools!.castHiveList().cast<Pool>()){
      if (pool.dayOffList!.contains(dayOff)){
        return true;
      }
    }
    return false;
  }
}

class DayOffDataSource extends CalendarDataSource {

  DayOffDataSource(List<DayOff> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].dateStart;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].dateEnd;
  }

  @override
  String getSubject(int index) {
    String subject = appointments![index].name;
    if (appointments![index].isHalfDay){
      subject += " (Half day)";
    }
    return subject;
  }

  @override
  Color getColor(int index) {
    return Colors.green;
  }

  @override
  bool isAllDay(int index) {
    // always return true so we do not show hours
    return true;
  }

}