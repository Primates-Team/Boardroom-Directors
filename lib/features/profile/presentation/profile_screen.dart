import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kGreyBackground,
      appBar: AppTheme.appBar('Profile', context, false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: AppTheme.boxDecoration
                .copyWith(color: AppColors.kLightGreyContainer),
            child: Column(
              children: [
                Row(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: SizedBox(
                        height: 75,
                        width: 75,
                        child: Image.network(
                          AppHelpers.SHARED_PREFERENCES
                                  .getString('profilepic') ??
                              '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 45.w,
                    ),
                    Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${AppHelpers.SHARED_PREFERENCES.getString('firstName')} ${AppHelpers.SHARED_PREFERENCES.getString('lastName')}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Last Activity At 04/04/2022',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                rowWidget('Gender',
                    AppHelpers.SHARED_PREFERENCES.getString('gender') ?? ''),
                rowWidget(
                    'Designation',
                    AppHelpers.SHARED_PREFERENCES.getString('designation') ??
                        ''),
                rowWidget(
                    'Department',
                    AppHelpers.SHARED_PREFERENCES.getString('department') ??
                        ''),
                rowWidget('Email',
                    AppHelpers.SHARED_PREFERENCES.getString('email') ?? ''),
                rowWidget('Mobile Number',
                    AppHelpers.SHARED_PREFERENCES.getString('phone') ?? ''),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget rowWidget(String key, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
