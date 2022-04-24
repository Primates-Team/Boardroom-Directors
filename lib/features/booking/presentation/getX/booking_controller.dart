import 'package:get/get.dart';

class BookingController extends GetxController {
  static BookingController instance = Get.find();

  // RxList<BookedSeats> bookedSeats = [BookedSeats(tableNo: 0, seatNo: 0)].obs;
  RxMap<int, List<int>> bookedSeats = {
    0: [0]
  }.obs;
  RxList<int> bookedRooms = [0].obs;
}
