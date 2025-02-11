class GooglePlaceModel {
  double lat;
  double lng;
  String formattedAddress;
  String shortAddressName;
  String locationAddressFull;
  String countryName;
  String cityName;
  String stateName;

  GooglePlaceModel({
    this.lat = 0.0,
    this.lng = 0.0,
    this.formattedAddress = '',
    this.shortAddressName = '',
    this.locationAddressFull = '',
    this.countryName = '',
    this.cityName = '',
    this.stateName = '',
  });
}

class LatLong {
  final double latitude;
  final double longitude;

  LatLong({required this.latitude, required this.longitude});
}
