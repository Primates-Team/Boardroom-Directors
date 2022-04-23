enum SeatStatus { Available, Booked, Selected, AvailableSoon }

class RoomModel {
  final int tableNo;
  final List<SeatModel> seats;

  RoomModel({
    required this.tableNo,
    required this.seats,
  });
}

class SeatModel {
  final int seatNo;
  final SeatStatus status;

  SeatModel({required this.seatNo, this.status = SeatStatus.Available});
}

class BookedSeats {
  final int tableNo;
  final int seatNo;

  BookedSeats({
    required this.tableNo,
    required this.seatNo,
  });
}
