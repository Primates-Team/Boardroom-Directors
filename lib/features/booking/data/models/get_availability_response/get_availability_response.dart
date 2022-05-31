class GetAvailabilityResponse {
  int? id;
  String? name;
  String? address;
  String? deviceid;
  dynamic features;
  String? noofpax;
  String? floor;
  dynamic purpose;
  String? createdAt;
  String? updatedAt;

  GetAvailabilityResponse({
    this.id,
    this.name,
    this.address,
    this.deviceid,
    this.features,
    this.noofpax,
    this.floor,
    this.purpose,
    this.createdAt,
    this.updatedAt,
  });

  factory GetAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return GetAvailabilityResponse(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      deviceid: json['deviceid'] as String?,
      features: json['features'] as dynamic,
      noofpax: json['noofpax'] as String?,
      floor: json['floor'] as String?,
      purpose: json['purpose'] as dynamic,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'deviceid': deviceid,
        'features': features,
        'noofpax': noofpax,
        'floor': floor,
        'purpose': purpose,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
