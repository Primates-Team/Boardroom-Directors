import 'package:get/get.dart';

class BookingController extends GetxController {
  static BookingController instance = Get.find();

  // RxList<BookedSeats> bookedSeats = [BookedSeats(tableNo: 0, seatNo: 0)].obs;
  RxMap<int, List<int>> bookedSeats = {
    2: [
      4,
    ],
  }.obs;

  List<Map<int, int>> tableData = [];

  RxList<int> bookedRooms = [0].obs;

//  Future<void> getbookedSeats(String date) async {
//     String url = '/roombooking/viewbydate';
//     var client = http.Client();
//     try {
//       var response = await client.post(Uri.parse(AppUrl.baseUrl + url), body: {"selecteddate": date, "floor": _selectedLevel});

//       if(response.statusCode == 200){
//          if(jsonDecode(response.body) is List){
//            bookedSeats = jsonDecode(response.body);
//            setState(() {

//            });
//          } else{
//            bookedSeats.clear();
//            setState(() {

//            });
//          }
//       }else{
//        bookedSeats.clear();
//         setState(() {

//         });
//       }

  // } catch (e) {
  // showSnackBar(
  //     context: Get.context!, message: e.toString(), bgColor: Colors.red);

  // }
}
