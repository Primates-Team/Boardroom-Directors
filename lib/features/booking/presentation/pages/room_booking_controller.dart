import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hot_desking/features/booking/data/datasource/room_booking_datasource.dart';

class RoomBookingController extends GetxController with StateMixin {
  Future<void> createBooking(int roomId, String date, String fromTime,
      String toTime, List<String> members, String floor) async {
    change(null, status: RxStatus.loading());

    Get.back();

    var response = await RoomBookingDataSource().createRoomBooking(
        roomId: roomId,
        date: date,
        fromTime: fromTime,
        toTime: toTime,
        members: members,
        floor: floor);

    if (response) {
      change(null, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.error());
    }

    //     .then((value) {
    //   if (value) {
    //     Get.back();
    //     showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (context) {
    //           return BackdropFilter(
    //             filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
    //             child: Dialog(
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(20.0)),
    //               child: BookingConfirmedWidget(
    //                   _formattedStartTime!, _formattedEndTime!),
    //             ),
    //           );
    //         });
    //     RoomBookingDataSource().viewAllRoomBooking();
    //   } else {
    //     Get.back();
    //   }
    // });
  }
}
