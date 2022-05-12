import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/core/app_urls.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/booking/data/datasource/room_booking_datasource.dart';
import 'package:hot_desking/features/booking/data/datasource/table_booking_datasource.dart';
import 'package:hot_desking/features/booking/data/models/availabilty_response.dart';
import 'package:hot_desking/features/booking/widgets/booking_confirmed_dialog.dart';
import 'package:hot_desking/features/booking/widgets/confirm_button.dart';
import 'package:hot_desking/features/login/data/datasource/auth_datasource.dart';
import 'package:hot_desking/features/login/data/model/get_user_response.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../../login/presentation/pages/login_screen.dart';

//import 'package:hot_desking/features/floors/level3/level_3_layout.dart';
//import 'package:hot_desking/features/booking/widgets/seat_selection_dialog.dart';
//import 'package:hot_desking/features/floors/level3/level_3_room.dart';
//import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class RoomBookingScreen extends StatefulWidget {
  final String type;

  const RoomBookingScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  _RoomBookingScreenState createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> {
  final List<String> _levelsList = [
    'Floor 3',
    'Floor 14',
  ];

  List rooms = [];
  List bookedRooms = [];
  String? _selectedLevel = 'Floor 3';
  DateTime? _dateTime;
  TimeOfDay? _startTime, _endTime;
  String? _formattedDate, _formattedStartTime, _formattedEndTime;
  late int _selectedCategory;
  var _selectedPax = 1.obs;
  int? tableNo, seatNo, roomId;
  List<String> paxEmailList = [];

  List<GetUserResponse> users = [];

  List<String> userList = [];

  String dropdownValue = "One";

  List<int> bookedRooomsIdList = [];

  bool _isLoading = false;

  String firstName =
      AppHelpers.SHARED_PREFERENCES.getString('firstName') ?? 'John';
  String lastName =
      AppHelpers.SHARED_PREFERENCES.getString('lastName') ?? 'Doe';

  String? profilePic = AppHelpers.SHARED_PREFERENCES.getString('profilepic');

  Future<void> getRoomid() async {
    String url = '/facilityaccess/viewall';
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(AppUrl.baseUrl + url));
      var jsonString = response.body;
      print(response);
      roomId = jsonDecode(jsonString)[0]['id'];
      // rooms = jsonDecode(jsonString);
      rooms.clear();
      (jsonDecode(jsonString) as List).forEach((element) {
        if (element['floor'] != null && element['floor'] == _selectedLevel) {
          rooms.add(element);
        }
      });
    } catch (e) {
      // showSnackBar(
      //     context: Get.context!, message: e.toString(), bgColor: Colors.red);

    }
  }

  Future<void> getBookedRooms(String date) async {
    String url = '/roombooking/viewbydate';
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(AppUrl.baseUrl + url),
          body: {"selecteddate": date, "floor": _selectedLevel});

      if (response.statusCode == 200) {
        if (jsonDecode(response.body) is List) {
          bookedRooms = jsonDecode(response.body);
          setState(() {});
        } else {
          bookedRooms.clear();
          setState(() {});
        }
      } else {
        bookedRooms.clear();
        setState(() {});
      }
    } catch (e) {
      // showSnackBar(
      //     context: Get.context!, message: e.toString(), bgColor: Colors.red);

    }
  }

  @override
  void initState() {
    if (widget.type == 'meeting room') {
      _selectedCategory = 0;
    } else {
      _selectedCategory = 1;
    }
    getRoomid();
    AuthDataSource().GetAllUser().then((value) {
      if (value != null) {
        users = value;
        userList = value.map((e) => e.email ?? '').toList();
      }
    });

    super.initState();
  }

  var black600TextStyle = TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black.withOpacity(0.5));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kGreyBackground,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              // controller: controller,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios),
                        ),
                        GestureDetector(
                          onTap: () {
                            AppHelpers.SHARED_PREFERENCES.clear();
                            pushAndRemoveUntilScreen(context,
                                screen: const LoginScreen(), withNavBar: false);
                          },
                          child: Image.asset(
                            'assets/welcome_screen/log_out.png',
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        profilePic != null
                            ? Container(
                                clipBehavior: Clip.hardEdge,
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                child: Image.network(
                                  profilePic ?? '',
                                  height: 55,
                                ),
                              )
                            : Image.asset(
                                'assets/welcome_screen/person_emoji.png',
                                height: 55,
                              ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 22.sp),
                            children: [
                              const TextSpan(
                                text: 'Welcome ',
                                style: TextStyle(
                                  color: AppColors.kAubergine,
                                ),
                              ),
                              TextSpan(
                                text: '$firstName $lastName',
                                style: const TextStyle(
                                  color: AppColors.kEvergreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Reserve Your \nMeeting Room',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 34.h,
                          width: 152.w,
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                value: _selectedLevel,
                                style: black600TextStyle,
                                hint: Text(
                                  'Level',
                                  style: black600TextStyle,
                                ),
                                isExpanded: true,
                                iconEnabledColor: Colors.black.withOpacity(0.5),
                                items: _levelsList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value.toString(),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? val) {
                                  setState(() {
                                    _selectedLevel = val!;
                                  });
                                  getRoomid();
                                }),
                          ),
                        ),
                        // paxSelector(),
                        startDateSelector(context),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        fromDateSelector(context, setState),
                        toDateSelector(context, setState),
                        // Container(
                        //   height: 34.h,
                        //   width: 152.w,
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 6, horizontal: 14),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10),
                        //     color: Colors.white,
                        //   ),
                        //   child: InkWell(
                        //     onTap: () {
                        //       Get.bottomSheet(
                        //         timeBottomSheet(),
                        //       );
                        //       // showTimePicker(
                        //       //   context: context,
                        //       //   initialTime: TimeOfDay.now(),
                        //       // ).then((value) {
                        //       //   if (value == null) return;
                        //       //   setState(() {
                        //       //     _formattedTime = AppHelpers.formatTime(value);
                        //       //     _timeOfDay = value;
                        //       //   });
                        //       // });
                        //     },
                        //     child: Center(
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text(
                        //             _formattedStartTime ?? 'Select Time',
                        //             style: black600TextStyle,
                        //           ),
                        //           Icon(
                        //             Icons.arrow_drop_down,
                        //             color: Colors.black.withOpacity(0.5),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    // Text(
                    //   _selectedLevel ?? 'Select Level',
                    //   style: AppTheme.black500TextStyle(18),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //   child: Row(
                    //     children: const [
                    //       Text(
                    //         'Desk: ',
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       Expanded(
                    //           child: Text(
                    //         '50 available',
                    //         style: TextStyle(
                    //           color: AppColors.kMint,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       )),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Text(
                        '* Room Booking can be done 3 months in Advance',
                        style: AppTheme.black400TextStyle(13),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Available room in the selected time slot',
                        style: AppTheme.black600TextStyle(18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Room Name',
                            style: AppTheme.black600TextStyle(14),
                          ),
                          Text(
                            'Max Pax',
                            style: AppTheme.black600TextStyle(14),
                          ),
                          Text(
                            'Available          ',
                            style: AppTheme.black600TextStyle(14),
                          ),
                        ],
                      ),
                    ),
                    if (_formattedDate != null &&
                        _startTime != null &&
                        roomId != null &&
                        _endTime != null)
                      FutureBuilder<List<int>>(
                        future: viewAvailablity(), // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<List<int>> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Text('Loading....');
                            default:
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              else
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: rooms.length,
                                    itemBuilder: (context, index) {
                                      return buildAvailabilityList(index);
                                    });
                          }
                        },
                      )

                    // _selectedLevel == 'Floor 14'
                    //     ? Level14Room(
                    //         selectedRoom: (s) {
                    //           roomId = s;
                    //           print(roomId);
                    //         },
                    //       )
                    //     : Level3Room(selectedRoom: (s) {
                    //         roomId = s;
                    //         print(roomId);
                    //       }),
                    // Center(
                    //   child: TextButton(
                    //     onPressed: () {
                    //       showDialog(
                    //           context: context,
                    //           builder: (context) {
                    //             return BackdropFilter(
                    //               filter:
                    //                   ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                    //               child: Dialog(
                    //                 shape: RoundedRectangleBorder(
                    //                     borderRadius: BorderRadius.circular(20.0)),
                    //                 child: SeatSelection(),
                    //               ),
                    //             );
                    //           });
                    //     },
                    //     child: const Text('Seat Selection'),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }

  Widget buildAvailabilityList(int index) {
    if (bookedRooomsIdList.contains(rooms[index]['id'])) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              rooms[index]['name'] != null
                  ? '${rooms[index]['name']}'
                  : "Room A",
              style: AppTheme.black500TextStyle(14),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rooms[index]['noofpax'] != null
                        ? rooms[index]['noofpax'].toString().length == 1
                            ? "0${rooms[index]['noofpax']}"
                            : "${rooms[index]['noofpax']}"
                        : "8",
                    style: AppTheme.black500TextStyle(14),
                  ),
                  InkWell(
                    onTap: () {
                      roomId = rooms[index]['id'];

                      Get.bottomSheet(
                        timeBottomSheet(index),
                        isScrollControlled: true,
                        isDismissible: true,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: AppColors.kEvergreen,
                      ),
                      child: Center(
                          child: Text(
                        'Available',
                        style: AppTheme.black500TextStyle(14),
                      )),
                    ),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  Widget timeBottomSheet(int index) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        // padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.75),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: ListView(
            children: [
              transparentWhiteContainer(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rooms[index]['name'] != null
                        ? '${rooms[index]['name']}'
                        : "Room A",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Time Slot',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )),
              const SizedBox(
                height: 15,
              ),
              transparentWhiteContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Room Amenities',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.kRed,
                            size: 15,
                          ),
                          Text(
                            '   Meeting Amenities',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.kRed,
                            size: 15,
                          ),
                          Text(
                            '   Projector',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.kRed,
                            size: 15,
                          ),
                          Text(
                            '   Available (If Any)',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              transparentWhiteContainer(
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'List of Pax',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    itemBuilder: (context, index2) {
                                      return DropdownButtonFormField<String>(
                                        value: null,
                                        hint: Text(
                                            "Select Invitee${index2 + 1} Email"),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            if (paxEmailList.isEmpty) {
                                              setState(() {
                                                paxEmailList
                                                    .add(newValue ?? '');
                                              });
                                            }

                                            if (paxEmailList.length <
                                                index2 + 1) {
                                              setState(() {
                                                paxEmailList
                                                    .add(newValue ?? '');
                                              });
                                            }

                                            setState(() {
                                              paxEmailList[index2] =
                                                  newValue ?? '';
                                            });
                                          });
                                        },
                                        validator: (String? value) {
                                          if (value?.isEmpty ?? true) {
                                            return "please Select Invitee${index2 + 1} Email";
                                          }
                                        },
                                        items: userList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,

                                              textScaleFactor: 0.85,
                                              // style: TextStyle(fontSize: 13),
                                            ),
                                          );
                                        }).toList(),
                                        // onSaved: (val) =>
                                        //     setState(() => _user.typeNeg = val),
                                      );
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: TextFormField(
                                          readOnly: false,
                                          autofocus: false,
                                          textInputAction: TextInputAction.done,
                                          onChanged: (value) {
                                            if (paxEmailList.isEmpty) {
                                              setState(() {
                                                paxEmailList.add(value);
                                              });
                                            }

                                            if (paxEmailList.length <
                                                index2 + 1) {
                                              setState(() {
                                                paxEmailList.add(value);
                                              });
                                            }

                                            setState(() {
                                              paxEmailList[index2] = value;
                                            });
                                            print("test");
                                          },
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontFeatures: const [
                                                FontFeature.tabularFigures()
                                              ],
                                              color: Colors.blueGrey[300],
                                              fontSize: 13),
                                          textAlign: TextAlign.start,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          obscureText: false,
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              fontFeatures: const [
                                                FontFeature.tabularFigures()
                                              ],
                                              color: Colors.blueGrey[300],
                                            ),
                                            hintText:
                                                "Select Invitee${index2 + 1} Email",
                                          ),
                                        ),
                                      );
                                    },
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: _selectedPax.value),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: paxSelector(index),
                              ),
                            ],
                          ),
                        ],
                      ))),
              const SizedBox(
                height: 15,
              ),
              transparentWhiteContainer(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // paxSelector(index),
                      Text(
                        'Date: $_formattedDate',
                        style: AppTheme.black500TextStyle(14),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start time: $_formattedStartTime',
                        style: AppTheme.black500TextStyle(14),
                      ),
                      Text(
                        'End time: $_formattedEndTime',
                        style: AppTheme.black500TextStyle(14),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        if (_selectedLevel != null &&
                            _dateTime != null &&
                            _startTime != null &&
                            _endTime != null) {
                          if (_selectedPax.value != paxEmailList.length) {
                            showSnackBar(
                                context: context,
                                message: 'Enter All Pax Emails');
                            return;
                          }

                          paxEmailList.forEach((element) {
                            if (!element.isEmail) {
                              showSnackBar(
                                  context: context,
                                  message: 'Enter Valid Pax Email');
                              return;
                            }

                            if (element == paxEmailList.last) {
                              setState(() {
                                _isLoading = true;
                              });

                              RoomBookingDataSource()
                                  .createRoomBooking(
                                      roomId: roomId!,
                                      date: _formattedDate!,
                                      fromTime: _formattedStartTime!,
                                      toTime: _formattedEndTime!,
                                      members: paxEmailList,
                                      floor: _selectedLevel ?? 'Floor 3')
                                  .then((value) {
                                if (value) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2.5, sigmaY: 2.5),
                                          child: Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: BookingConfirmedWidget(
                                                _formattedStartTime!,
                                                _formattedEndTime!),
                                          ),
                                        );
                                      });
                                  RoomBookingDataSource().viewAllRoomBooking();
                                } else {
                                  Navigator.pop(context);
                                }
                              });
                            }
                          });
                        } else {
                          showSnackBar(
                              context: context, message: 'Select All Fields');
                        }
                      },
                      child: confirmButton(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ))
            ],
          ),
        ),
      );
    });
  }

  Widget startDateSelector(BuildContext context) {
    return Container(
      height: 34.h,
      width: 152.w,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)))
              .then((value) {
            if (value == null) return;
            setState(() {
              _formattedDate = AppHelpers.formatDate(value);
              _dateTime = value;
            });
          });
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formattedDate ?? 'Select Date',
                style: black600TextStyle,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fromDateSelector(
      BuildContext context, void Function(void Function()) setState) {
    return Container(
      height: 34.h,
      width: 152.w,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          AppHelpers.showCupertinoTimePicker(context, (value) {
            setState(() {
              _formattedStartTime =
                  AppHelpers.formatTime(TimeOfDay.fromDateTime(value));
              _startTime = TimeOfDay.fromDateTime(value);
            });
          });
          // showTimePicker(
          //         initialEntryMode: TimePickerEntryMode.input,
          //         context: context,
          //         initialTime: TimeOfDay.now())
          //     .then((value) {
          //   if (value == null) return;
          //   setState(() {
          //     _formattedStartTime = AppHelpers.formatTime(value);
          //     _startTime = value;
          //   });
          // });
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formattedStartTime ?? 'Start Time',
                style: black600TextStyle,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toDateSelector(
      BuildContext context, void Function(void Function()) setState) {
    return Container(
      height: 34.h,
      width: 152.w,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          AppHelpers.showCupertinoTimePicker(context, (value) {
            setState(() {
              if (value == null) return;
              setState(() {
                _formattedEndTime =
                    AppHelpers.formatTime(TimeOfDay.fromDateTime(value));
                _endTime = TimeOfDay.fromDateTime(value);
              });
            });
          });

          // showTimePicker(
          //         initialEntryMode: TimePickerEntryMode.input,
          //         context: context,
          //         initialTime: TimeOfDay.now())
          //     .then((value) {
          //   if (value == null) return;
          //   setState(() {
          //     _formattedEndTime = AppHelpers.formatTime(value);
          //     _endTime = value;
          //   });
          // });
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formattedEndTime ?? 'End Time',
                style: black600TextStyle,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paxSelector(int index) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        height: 34.h,
        width: 60.w,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              value: _selectedPax.value,
              style: black600TextStyle,
              hint: Text(
                'No. of pax',
                style: black600TextStyle,
              ),
              isExpanded: true,
              iconEnabledColor: Colors.black.withOpacity(0.5),
              items: List<int>.generate(
                      rooms[index]['available'] ?? 16, (i) => i + 1)
                  .map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                  ),
                );
              }).toList(),
              onChanged: (int? val) {
                if (_selectedPax.value == val) {
                  return;
                }

                if (_selectedPax.value > val!) {
                  for (int i = 0; i < val - _selectedPax.value; i++) {
                    paxEmailList.removeLast();
                  }
                }

                _selectedPax.value = val;
                setState(() {});
              }),
        ),
      );
    });
  }

  Widget transparentWhiteContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: child,
    );
  }

  Widget _buildTextcontrollers() {
    List<TextEditingController> controllers = [];

    for (int i = 0; 1 < _selectedPax.value; i++) {
      TextEditingController controller = TextEditingController();
      controllers.add(controller);
    }

    return Container();
  }

  Future<List<int>> viewAvailablity() async {
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.parse(AppUrl.availabalityNew),
        body: jsonEncode({
          "floor": _selectedLevel,
          "selecteddate": _formattedDate,
          "fromtime": _formattedStartTime,
          "totime": _formattedEndTime
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      if (response.statusCode == 200) {
        // var jsonString = response.body;
        // print(jsonString);
        Iterable l = json.decode(response.body);
        List<AvailabiltyResponse> bookedSlots = List<AvailabiltyResponse>.from(
            l.map((model) => AvailabiltyResponse.fromJson(model)));

        // List<BookedSeats> bookedSeats = [];

        for (var slot in bookedSlots) {
          if (isNumeric(slot.roomid!)) {
            // bookedSeats.add(BookedSeats(
            //     tableNo: int.parse(booking.tableid),
            //     seatNo: int.parse(booking.seatnumber)));
            bookedRooomsIdList.add(int.parse(slot.roomid!));
          }
        }
        bookedRooomsIdList = bookedRooomsIdList.toSet().toList();
        bookingController.bookedRooms.value = bookedRooomsIdList;

        return bookedRooomsIdList;
      } else {
        showSnackBar(
            context: Get.context!,
            message: 'Failed to Load',
            bgColor: Colors.red);
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
