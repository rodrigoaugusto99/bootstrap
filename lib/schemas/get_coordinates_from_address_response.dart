class GetCoordinatesFromAddressResponse {
  GetCoordinatesFromAddressResponse(
      {required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory GetCoordinatesFromAddressResponse.fromMap(Map<String, dynamic> map) {
    return GetCoordinatesFromAddressResponse(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }
}
