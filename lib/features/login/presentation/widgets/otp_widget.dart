import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hot_desking/core/app_colors.dart';

class OTPWidget extends StatefulWidget {
  final bool? forgotPassword;
  final bool? register;
  OTPWidget(this.onSubmit, {Key? key, this.forgotPassword, this.register})
      : super(key: key);

  Function onSubmit;

  @override
  _OTPWidgetState createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  FocusNode textFirstFocusNode = FocusNode();
  FocusNode textSecondFocusNode = FocusNode();
  FocusNode textThirdFocusNode = FocusNode();
  FocusNode textFourthFocusNode = FocusNode();

  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: Center(
            child: Card(
          child: Container(
            height: 194,
            width: 343.92,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 34.6,
                    ),
                    const Text(
                      'OTP Verification',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 17.83,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _otp(1, textFirstFocusNode, otp1Controller),
                        const SizedBox(
                          width: 15.73,
                        ),
                        _otp(2, textSecondFocusNode, otp2Controller),
                        const SizedBox(
                          width: 15.73,
                        ),
                        _otp(3, textThirdFocusNode, otp3Controller),
                        const SizedBox(
                          width: 15.73,
                        ),
                        _otp(4, textFourthFocusNode, otp4Controller),
                        const SizedBox(
                          width: 15.73,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 26.84,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            '1:30 sec',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.kLightPantone),
                          ),
                          Text(
                            'Re-send OTP',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.kLightPantone),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 23),
                    child: _closeBox(),
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _otp(
          int index, FocusNode focusNode, TextEditingController controller) =>
      Container(
        height: 41.94,
        width: 41.94,
        decoration: BoxDecoration(
            color: AppColors.kLightPantone,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(185, 185, 185, 0.9),
                  spreadRadius: -8,
                  offset: Offset(3, 3)),
              BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  spreadRadius: -6,
                  offset: Offset(-3, -3)),
              BoxShadow(
                  color: Color.fromRGBO(185, 185, 185, 0.2),
                  spreadRadius: -6,
                  offset: Offset(3, -3)),
              BoxShadow(
                  color: Color.fromRGBO(185, 185, 185, 0.2),
                  spreadRadius: -6,
                  offset: Offset(-3, 3)),
              BoxShadow(
                  color: Color.fromRGBO(185, 185, 185, 0.5),
                  spreadRadius: 2,
                  offset: Offset(-1, -1),
                  blurRadius: 10,
                  blurStyle: BlurStyle.inner),
              BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.3),
                  spreadRadius: 2,
                  offset: Offset(1, 1),
                  blurRadius: 10,
                  blurStyle: BlurStyle.inner),
            ]),
        child: TextFormField(
          keyboardType: TextInputType.number,
          focusNode: focusNode,
          controller: controller,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(bottom: 0),
            hintText: '*',
            hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (val) {
            if (val.length == 1) {
              if (index == 1) textSecondFocusNode.requestFocus();
              if (index == 2) textThirdFocusNode.requestFocus();
              if (index == 3) textFourthFocusNode.requestFocus();
              if (index == 4) {
                if (widget.forgotPassword != null) {
                  widget.onSubmit(otp1Controller.text +
                      otp2Controller.text +
                      otp3Controller.text +
                      otp4Controller.text);
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                  // Navigator.push(
                  //     context,
                  //     PageTransition(
                  //         type: PageTransitionType.fade,
                  //         child: const ResetPasswordScreen(),
                  //         duration: const Duration(milliseconds: 250)));

                }
                textFourthFocusNode.unfocus();
              }
            }
            if (val.isEmpty) {
              if (index == 1) textFirstFocusNode.unfocus();
              if (index == 2) textFirstFocusNode.requestFocus();
              if (index == 3) textSecondFocusNode.requestFocus();
              if (index == 4) textThirdFocusNode.unfocus();
            }
          },
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
          showCursor: false,
        ),
      );

  Widget _closeBox() => Container(
        width: 42,
        height: 36,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(2, 2),
              ),
            ]),
        child: Center(
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.clear,
              size: 20,
              color: Color.fromRGBO(96, 108, 103, 1),
            ),
          ),
        ),
      );
}
