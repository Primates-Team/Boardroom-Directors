import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/widgets/rc.dart';
import 'package:hot_desking/features/current_booking/data/datasource/booked_ds.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_theme.dart';
import '../widgets/room_card.dart';

class BookingHistoryScreen extends StatefulWidget {
  BookingHistoryScreen({Key? key, this.isCalendarScreen = false})
      : super(key: key);

  bool? isCalendarScreen;

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  DateTime _selectedValue = DateTime.now();
  DatePickerController dateController = DatePickerController();
  List _all = [];
  // List _filter = [];
  bool _error = false;
  bool _processing = true;

  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => loadData());
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void loadData() async {
    // Map bd = await BookedDataSource.getBookingHistory(
    //     AppHelpers.formatDate(_selectedValue));

    Map bd = await BookedDataSource.getCurrentHistory(
        AppHelpers.formatDate(_selectedValue),
        AppHelpers.formatTime(TimeOfDay.now()));

    Map tt = await BookedDataSource.getCurrentHistoryTable(
        AppHelpers.formatDate(_selectedValue),
        AppHelpers.formatTime(TimeOfDay.now()));

    // Map tt = await BookedDataSource.getBookingMeetingHistory();

    if (bd.containsKey('flag') && bd['flag'] == false) {
      _error = true;
      _processing = false;
    }

    if (bd.containsKey('flag') && bd['flag'] == true) {
      _all = bd['data'];
      _error = false;
    }

    if (tt.containsKey('flag') && tt['flag'] == true) {
      _all.addAll(tt['data']);
      _error = false;
    }

    _processing = false;
    setState(() {});
    filter();
  }

  void filter() {
    if (_selectedValue == null) {
      _selectedValue = DateTime.now();
    }

    Future.delayed(Duration(milliseconds: 100),
        () => dateController.animateToDate(_selectedValue));

    String dt2 = _selectedValue.toString();
    var y = dt2.substring(0, 4);
    var mth = dt2.substring(5, 7);

    var dt = dt2.substring(8, 10);
    if (int.parse(mth) < 10) mth = mth.substring(1);
    if (int.parse(dt) < 10) dt = dt.substring(1);
//date format incompatibility

    String fin = dt + '-' + mth + '-' + y;

    // _filter = [];
    // _all.forEach((element) {

    //   if (element['selecteddate'] == fin.toString()) {
    //     _filter.add(element);
    //   }
    // });
    setState(() {});
  }

  Widget _drawList() {
    if (_error) return Center(child: Text("Error Occured"));
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _all.length,
        itemBuilder: (BuildContext context, int index) {
          var node = _all[index];
          if (node['tableid'] != null) {
            return Rc(node);
          } else {
            return RoomCard(
                showWarning: false,
                allowEdit: false,
                fromCurrentBooking: false,
                node: node,
                onRefresh: () {});
          }
        });
  }

  // Widget _drawList() {
  //   if (_error) return Center(child: Text("Error Occured"));
  //   return ListView.builder(
  //       physics: NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       itemCount: _filter.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         var node = _filter[index];
  //         if (node['tableid'] != null) {
  //           return Rc(node);
  //         } else {
  //           return RoomCard(
  //               showWarning: false,
  //               allowEdit: false,
  //               fromCurrentBooking: false,
  //               node: node,
  //               onRefresh: () {});
  //         }
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    bool isCalendarScreen = widget.isCalendarScreen ?? false;

    return Scaffold(
      backgroundColor: AppColors.kGreyBackground,
      appBar: AppTheme.appBar(
          isCalendarScreen ? "Calendar" : 'Booking History', context, false),
      body: _processing == true
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                loadData();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: DatePicker(
                          DateTime(DateTime.now().year - 1,
                              DateTime.now().month, DateTime.now().day),
                          controller: dateController,
                          initialSelectedDate: DateTime.now(),
                          selectionColor: Colors.black,
                          daysCount:
                              widget.isCalendarScreen == true ? 732 : 366,
                          selectedTextColor: Colors.white,
                          onDateChange: (date) {
                            setState(() {
                              _selectedValue = date;
                            });
                            // filter();

                            loadData();
                          },
                        ),
                      ),
                      Container(
                          // height: Get.height * 0.8,
                          child: _all.isEmpty
                              ? SingleChildScrollView(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height -
                                        kToolbarHeight -
                                        kBottomNavigationBarHeight -
                                        200,
                                    child: Center(
                                        child: Text("No bookings available")),
                                  ),
                                )
                              : _drawList()),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
