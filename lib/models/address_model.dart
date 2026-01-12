// ignore_for_file: public_member_api_docs, sort_constructors_first
class AddressModel {
  String postalCode;
  String street;
  String number;
  String? complement;
  String neighborhood;
  String city;
  String state;
  double latitude;
  double longitude;

  AddressModel({
    required this.postalCode,
    required this.street,
    required this.number,
    this.complement,
    this.latitude = 0.0,
    this.longitude = 0.0,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  String get formattedAddress {
    return '$street, $number, $neighborhood, $city, $state, $postalCode';
  }

  factory AddressModel.fromMap(Map<String, dynamic> json) {
    return AddressModel(
      postalCode: json['postalCode'] ?? "",
      street: json['street'] ?? "",
      number: json['number'] ?? "",
      complement: json['complement'],
      neighborhood: json['neighborhood'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      latitude: json['latitude'] == null || json['latitude'] == 0
          ? 0.0
          : json['latitude'].toDouble(),
      longitude: json['longitude'] == null || json['longitude'] == 0
          ? 0.0
          : json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postalCode': postalCode,
      'street': street,
      'number': number,
      'complement': complement ?? '',
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.postalCode == postalCode &&
        other.street == street &&
        other.number == number &&
        other.complement == complement &&
        other.neighborhood == neighborhood &&
        other.city == city &&
        other.state == state &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return postalCode.hashCode ^
        street.hashCode ^
        number.hashCode ^
        complement.hashCode ^
        neighborhood.hashCode ^
        city.hashCode ^
        state.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
