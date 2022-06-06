class AppUrl {
  static const String baseUrl = 'http://54.147.217.183:3001';
  static const String createUser = '$baseUrl/users/create';
  static const String viewAllUsers = '$baseUrl/users/viewall';
  static const String login = '$baseUrl/users/login';
  //table
  static const String viewAllTableBookings = '$baseUrl/booking/viewall';
  static const String createTableBooking = '$baseUrl/booking/create';
  static const String updateTableBooking = '$baseUrl/booking/update';
  static const String tableAvailabalityNew = '$baseUrl/booking/availabilitynew';
  //room
  static const String viewAllRoomBookings = '$baseUrl/roombooking/viewall';
  static const String createRoomBooking = '$baseUrl/roombooking/create';
  static const String updateRoomBooking = '$baseUrl/roombooking/update';
  //history
  static const String viewByEmployee = '$baseUrl/booking/viewbyemployee';
  static const String viewMeetingByEmployee =
      '$baseUrl/roombooking/viewbyemployee';

  static const String viewByTime = '$baseUrl/roombooking/viewbytime';
  static const String viewByTimeTable = '$baseUrl/booking/viewbytime';

  static const String tableviewbydateemployee =
      '$baseUrl/booking/viewbydateemployee';
  static const String roomviewbydateemployee =
      '$baseUrl/roombooking/viewbydateemployee';

  static const String roomBookingHistory =
      '$baseUrl/roombooking/bookinghistory';

  static const String tableBookingHistory = '$baseUrl/booking/bookinghistory';

  static const String tableBookedByFloor = '$baseUrl/booking/viewbydate';

  static const String tableBookedByFloorDateTime =
      '$baseUrl/booking/viewbydatetime';

  static const String cancleMeeting = '$baseUrl/roombooking/cancelbooking';
  static const String tablecancleMeeting = '$baseUrl/booking/update';

  static const String viewByDateTime = '$baseUrl/roombooking/viewbydatetime';
  static const String availabalityNew = '$baseUrl/roombooking/availabilitynew';
  static const String getAvailability = '$baseUrl/roombooking/roomdetails';

  static const String sendOtp = '$baseUrl/users/sendotp';
  static const String verifyOtp = '$baseUrl/users/verifyotp';
  static const String viewByEmail = '$baseUrl/users/viewbyemail';
  static const String userUpdate = '$baseUrl/users/update';
}
