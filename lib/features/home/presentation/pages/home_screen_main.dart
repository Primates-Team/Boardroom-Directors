import 'package:flutter/material.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/features/booking_history/presentation/pages/booking_history_screen.dart';
import 'package:hot_desking/features/home/presentation/widgets/custom_nav_bar_widget.dart';
import 'package:hot_desking/features/profile/presentation/profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../../current_booking/presentation/pages/current_booking_screen.dart';
import 'home_screen.dart';

class HomeScreenMain extends StatefulWidget {
  const HomeScreenMain({Key? key}) : super(key: key);

  @override
  _HomeScreenMainState createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            PersistentTabView.custom(
              context,
              // hideNavigationBar: true,
              controller: _controller,
              itemCount: 4,
              // This is required in case of custom style! Pass the number of items for the nav bar.
              screens: const [
                HomeScreen(),
                CurrentBookingScreen(),
                BookingHistoryScreen(),
                ProfileScreen(),
              ],
              confineInSafeArea: false,
              backgroundColor: AppColors.kAubergine,
              handleAndroidBackButtonPress: true,
              customWidget: SizedBox(
                width: size.width,
                child: Stack(
                  children: [
                    CustomNavBarWidget(
                      selectedIndex: _controller.index,
                      onItemSelected: (index) {
                        setState(() {
                          _controller.index = index; // NOTE: THIS IS CRITICAL!! Don't miss it!
                        });
                      },
                    ),
                    SizedBox(
                      height: 110,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              radius: 15,
                              onTap: () {
                                _controller.jumpToTab(0);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset(
                                      'assets/common/home.png',
                                      width: 27,
                                      height: 27,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Home',
                                    style: TextStyle(fontSize: 8, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            //home
                            InkWell(
                              radius: 15,
                              onTap: () {
                                _controller.jumpToTab(1);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/common/list.png',
                                    width: 27,
                                    height: 27,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Current Booking',
                                    style: TextStyle(fontSize: 8, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            //home
                            InkWell(
                              radius: 15,
                              onTap: () {
                                _controller.jumpToTab(2);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/common/chart.png',
                                    width: 27,
                                    height: 27,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Booking History',
                                    style: TextStyle(fontSize: 8, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            //home
                            InkWell(
                              radius: 15,
                              onTap: () {
                                _controller.jumpToTab(3);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/common/person.png',
                                    width: 27,
                                    height: 27,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Profile',
                                    style: TextStyle(fontSize: 8, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Align(
            //   alignment: const Alignment(0, 0.83),
            //   child: Container(
            //     height: 50,
            //     width: 98,
            //     decoration: const BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.only(
            //             bottomLeft: Radius.circular(50),
            //             bottomRight: Radius.circular(50))),
            //   ),
            // ),
            // Align(
            //   alignment: const Alignment(0, 0.805),
            //   child: Container(
            //     height: 88,
            //     width: 88,
            //     decoration: BoxDecoration(
            //         color: AppColors.kAubergine,
            //         borderRadius: BorderRadius.circular(100)),
            //     child: Center(
            //         child: Image.asset(
            //       'assets/common/scanner.png',
            //       height: 50.h,
            //       width: 48.w,
            //     )),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
