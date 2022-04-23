class AppUrl {
  static const String baseUrl = 'http://54.147.217.183:3001';
  static const String createUser = '$baseUrl/users/create';
  static const String viewAllUsers = '$baseUrl/users/viewall';
  //table
  static const String viewAllTableBookings = '$baseUrl/booking/viewall';
  static const String createTableBooking = '$baseUrl/booking/create';
  static const String updateTableBooking = '$baseUrl/booking/update';
  //room
  static const String viewAllRoomBookings = '$baseUrl/roombooking/viewall';
  static const String createRoomBooking = '$baseUrl/roombooking/create';
  static const String updateRoomBooking = '$baseUrl/roombooking/update';
  //history
  static const String viewByEmployee = '$baseUrl/booking/viewbyemployee';
  static const String viewMeetingByEmployee = '$baseUrl/roombooking/viewbyemployee';


  static const String viewByTime = '$baseUrl/roombooking/viewbytime';
  static const String viewByTimeTable = '$baseUrl/booking/viewbytime';



  static const String tableBookedByFloor = '$baseUrl/booking/viewbydate';

  static const String cancleMeeting = '$baseUrl/roombooking/cancelbooking';
  static const String tablecancleMeeting = '$baseUrl/booking/update';
}
