import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/features/login/data/model/user_model.dart';
import 'package:hot_desking/features/login/presentation/widgets/registration_pin_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  List<String> genderOptions = ['Male', 'Female', 'Other'];
  List<String> departmentOptions = [
    'Operations Department',
    'Sales Department',
    'Purchase Department'
  ];
  List<String> designationOptions = [
    'Managing Director',
    'Chief Executive Officer',
    'Chief Operating Officer'
  ];
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController designation = TextEditingController();
  final TextEditingController department = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _image;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                      ],
                    ),
                    //logo
                    Image.asset(
                      'assets/common/logo.png',
                      width: 248,
                      height: 104,
                    ),
                    //first name
                    const SizedBox(
                      height: 28,
                    ),
                    SizedBox(
                      // height: 48,
                      width: 343,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: firstName,
                            decoration:
                                AppTheme.textFieldDecoration('First Name'),
                            validator: (s) =>
                                s!.isEmpty ? 'Field required' : null,
                            style: const TextStyle(
                                color: AppColors.kDarkPantone,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 11),
                            child: Image.asset(
                              'assets/login/user_name.png',
                              height: 25,
                              width: 25,
                              color: AppColors.kDarkPantone,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      // height: 48,
                      width: 343,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: lastName,
                            decoration:
                                AppTheme.textFieldDecoration('Last Name'),
                            validator: (s) =>
                                s!.isEmpty ? 'Field required' : null,
                            style: const TextStyle(
                                color: AppColors.kDarkPantone,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 11),
                            child: Image.asset(
                              'assets/login/user_name.png',
                              height: 25,
                              width: 25,
                              color: AppColors.kDarkPantone,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      // height: 48,
                      width: 343,
                      child: Stack(
                        children: [
                          DropdownButtonFormField(
                            iconSize: 20,
                            decoration:
                                AppTheme.textFieldDecoration('Gender').copyWith(
                              contentPadding:
                                  EdgeInsets.only(left: 55.w, right: 15.w),
                            ),
                            onChanged: (String? val) =>
                                setState(() => gender.text = val!),
                            validator: (value) =>
                                value == null ? 'Please select Gender' : null,
                            items: genderOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(
                                      color: AppColors.kDarkPantone,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              );
                            }).toList(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 11),
                            child: Image.asset(
                              'assets/login/user_name.png',
                              height: 25,
                              width: 25,
                              color: AppColors.kDarkPantone,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      // height: 48,
                      width: 343,
                      child: Stack(
                        children: [
                          DropdownButtonFormField(
                            iconSize: 20,
                            decoration:
                                AppTheme.textFieldDecoration('Designation')
                                    .copyWith(
                              contentPadding:
                                  EdgeInsets.only(left: 55.w, right: 15.w),
                            ),
                            onChanged: (String? val) =>
                                setState(() => designation.text = val!),
                            validator: (value) => value == null
                                ? 'Please select Designation'
                                : null,
                            items: designationOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(
                                      color: AppColors.kDarkPantone,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              );
                            }).toList(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 11),
                            child: Image.asset(
                              'assets/common/scanner.png',
                              height: 25,
                              width: 25,
                              color: AppColors.kDarkPantone,
                            ),
                          )
                        ],
                      ),
                    ),
                    //
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      // height: 48,
                      width: 343,
                      child: Stack(
                        children: [
                          DropdownButtonFormField(
                            iconSize: 20,
                            decoration:
                                AppTheme.textFieldDecoration('Department')
                                    .copyWith(
                              contentPadding:
                                  EdgeInsets.only(left: 55.w, right: 15.w),
                            ),
                            onChanged: (String? val) =>
                                setState(() => department.text = val!),
                            validator: (value) => value == null
                                ? 'Please select Department'
                                : null,
                            items: departmentOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(
                                      color: AppColors.kDarkPantone,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              );
                            }).toList(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 11),
                            child: Image.asset(
                              'assets/common/imei.png',
                              height: 25,
                              width: 25,
                              color: AppColors.kDarkPantone,
                            ),
                          )
                        ],
                      ),
                    ),
                    //email
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      // height: 48,
                      width: 343,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: email,
                            decoration: AppTheme.textFieldDecoration('Email'),
                            validator: (s) =>
                                !GetUtils.isEmail(s!) ? 'Email required' : null,
                            style: const TextStyle(
                                color: AppColors.kDarkPantone,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 11),
                            child: Image.asset(
                              'assets/common/email.png',
                              height: 25,
                              width: 25,
                              color: AppColors.kDarkPantone,
                            ),
                          )
                        ],
                      ),
                    ),
                    //mobile number
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      // height: 48,
                      width: 343,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: mobile,
                            decoration:
                                AppTheme.textFieldDecoration('Mobile Number'),
                            validator: (s) => !GetUtils.isPhoneNumber(s!)
                                ? 'Mobile number required'
                                : null,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                color: AppColors.kDarkPantone,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 11),
                            child: Image.asset(
                              'assets/common/mobile.png',
                              height: 25,
                              width: 25,
                              color: AppColors.kDarkPantone,
                            ),
                          )
                        ],
                      ),
                    ),
                    //image upload
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Upload profile image',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        InkWell(
                          onTap: () => _showImageSelector(),
                          child: const Icon(Icons.upload_outlined),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_image != null)
                      SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )),
                    //register
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate() &&
                            _image != null) {
                          setState(() {
                            _isLoading = true;
                          });
                          FirebaseStorage.instance
                              .ref(email.text)
                              .putFile(_image!)
                              .then((data) {
                            if (data.metadata != null) {
                              FirebaseStorage.instance
                                  .ref(data.metadata!.fullPath)
                                  .getDownloadURL()
                                  .then((url) {
                                UserModel user = UserModel(
                                    firstName: firstName.text,
                                    lastName: lastName.text,
                                    gender: gender.text,
                                    designation: designation.text,
                                    mobile: mobile.text,
                                    email: email.text,
                                    profileUrl: url);
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child:
                                            RegistrationPinWidget(user: user),
                                        duration:
                                            const Duration(milliseconds: 250)));
                              }).catchError((onError) {
                                _showError();
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                            } else {
                              _showError();
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }).catchError((onError) {
                            _showError();
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        }
                        if (_image == null) {
                          Get.snackbar('Profile Image required', '',
                              colorText: Colors.white,
                              backgroundColor: Colors.black87);
                        }
                      },
                      child: Container(
                        height: 57,
                        width: 343,
                        decoration: BoxDecoration(
                          color: AppColors.kAubergine,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                            child: Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        )),
                      ),
                    ),
                    const SizedBox(
                      height: 53,
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                width: size.width,
                height: size.height,
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    XFile? image;
    final picker = ImagePicker();
    image = await picker.pickImage(source: source);
    if (image != null) {
      Navigator.pop(context);
      setState(() {
        _image = File(image!.path);
      });
    }
  }

  void _showImageSelector() {
    Get.bottomSheet(Container(
      color: Colors.white,
      height: 150,
      child: Column(
        children: [
          ListTile(
            onTap: () => _pickImage(ImageSource.gallery),
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
          ),
          ListTile(
            onTap: () => _pickImage(ImageSource.camera),
            leading: const Icon(Icons.camera),
            title: const Text('Camera'),
          )
        ],
      ),
    ));
  }

  void _showError() {
    Get.snackbar('Error occurred', 'Try again',
        colorText: Colors.white, backgroundColor: Colors.black87);
  }
}
