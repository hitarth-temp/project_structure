import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api_constant.dart';

import '../../core/utils/app_logger.dart';
import '../../core/utils/dialog_utils.dart';
import '../../localization/app_strings.dart';
import '../internet_service.dart';
import 'google_place_model.dart';

class GooglePlaceService with ChangeNotifier {
  static final _dio = Dio();

  static Future<List> getGooglePlaceSuggestion(
    String query, {
    bool requireFields = true,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    var url = '';
    url = requireFields
        ? '${Constants.mapApiBaseUrl}/place/autocomplete/json?input=$query&fields=place_id,geometry,formatted_address,name&types=establishment&key=${Constants.googleMapKey}&sessiontoken=1234567890'
        : '${Constants.mapApiBaseUrl}/place/autocomplete/json?input=$query&key=${Constants.googleMapKey}&sessiontoken=1234567890';
    logger.e('URL ==$url');
    final response = await _dio.get(url);
    List tList = [];
    for (int i = 0; i < response.data['predictions'].length; i++) {
      tList.add(response.data['predictions'][i]);
    }

    return tList;
  }

  static Future<GooglePlaceModel> getPlaceDetails({
    bool setAsLocation = false,
    String placeId = '',
    LatLong? latLng,
    CancelToken? cancelToken,
  }) async {
    var url = latLng == null
        ? '${Constants.mapApiBaseUrl}/place/details/json?placeid=$placeId&key=${Constants.googleMapKey}'
        : '${Constants.mapApiBaseUrl}/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${Constants.googleMapKey}';

    print('URL -- $url');

    if (Get.find<InternetService>().hasConnection.value) {
      final response = await _dio.get(url, cancelToken: cancelToken);

      dynamic responseDataResult;

      GooglePlaceModel? googlePlaceModel;

      if (latLng == null) {
        responseDataResult = response.data['result'];
      } else {
        if ((response.data['results'] as List).isNotEmpty) {
          responseDataResult = (response.data['results'])[0];
        } else {
          return GooglePlaceModel();
        }
      }

      double latitude = responseDataResult['geometry']['location']['lat'];
      double longitude = responseDataResult['geometry']['location']['lng'];

      String country = '';
      String state = '';
      String city = '';

      String subLocality = '';
      String locality = '';

      String formattedAddress = responseDataResult['formatted_address'];
      String shortAddressName = (latLng == null
              ? responseDataResult['name']
              : responseDataResult['premise']) ??
          formattedAddress;

      List list = responseDataResult['address_components'];
      if (list.isNotEmpty) {
        for (int i = 0; i < list.length; i++) {
          var data = list[i]['types'];

          // country
          if (data.toString().contains('country')) {
            country = list[i]['long_name'].toString();
          }

          // state
          else if (data.toString().contains('administrative_area_level_1')) {
            state = list[i]['long_name'].toString();
          }

          // city
          else if (data.toString().contains('administrative_area_level_3')) {
            city = list[i]['long_name'].toString();
          } else if (!data.toString().contains('administrative_area_level_3') &&
              data.toString().contains('neighborhood')) {
            city = list[i]['long_name'].toString();
          }

          // sub locality
          else if (data.toString().contains('sublocality_level_1')) {
            subLocality = list[i]['long_name'].toString();
          } else if (!data.toString().contains('sublocality_level_1') &&
              data.toString().contains('route')) {
            subLocality = list[i]['long_name'].toString();
          }

          // locality
          else if (data.toString().contains('locality')) {
            locality = list[i]['long_name'].toString();
          }
        }
      }

      googlePlaceModel = GooglePlaceModel(
        lat: latitude,
        lng: longitude,
        formattedAddress: formattedAddress,
        shortAddressName: shortAddressName,
        locationAddressFull: '$shortAddressName, $formattedAddress',
        countryName: country,
        cityName: city.isEmpty ? shortAddressName : city,
        stateName: state,
      );

      if (setAsLocation) {
        // ValueConstants.currentLatLng.value = LatLong(latitude, longitude);

        if (subLocality == '' || locality == '') {
          // ValueConstants.displayAddress.value = formattedAddress;
        } else {
          // ValueConstants.displayAddress.value = '$subLocality, $locality';
        }
      }

      return googlePlaceModel;
    } else {
      while (!Get.isSnackbarOpen) {
        DialogUtils.showSnackBar(
          AppStrings.noInternetConnection.tr,
          snackbarType: SnackbarType.failure,
        );
      }
      return GooglePlaceModel();
    }
  }
}
