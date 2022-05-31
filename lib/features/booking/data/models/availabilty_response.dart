class AvailabiltyResponse {
  int? id;
  String? roomid;
  String? selecteddate;
  String? fromtime;
  String? totime;
  String? employeeid;
  String? status;
  int? packs;
  String? floor;
  String? members;
  String? createdAt;
  String? updatedAt;

  AvailabiltyResponse({
    this.id,
    this.roomid,
    this.selecteddate,
    this.fromtime,
    this.totime,
    this.employeeid,
    this.status,
    this.packs,
    this.floor,
    this.members,
    this.createdAt,
    this.updatedAt,
  });

  factory AvailabiltyResponse.fromJson(Map<String, dynamic> json) {
    return AvailabiltyResponse(
      id: json['id'] as int?,
      roomid: json['roomid'] as String?,
      selecteddate: json['selecteddate'] as String?,
      fromtime: json['fromtime'] as String?,
      totime: json['totime'] as String?,
      employeeid: json['employeeid'] as String?,
      status: json['status'] as String?,
      packs: json['packs'] as int?,
      floor: json['floor'] as String?,
      members: json['members'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'roomid': roomid,
        'selecteddate': selecteddate,
        'fromtime': fromtime,
        'totime': totime,
        'employeeid': employeeid,
        'status': status,
        'packs': packs,
        'floor': floor,
        'members': members,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
