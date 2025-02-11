import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/loading_dialog.dart';

import '../../services/google_place/google_place_model.dart';
import '../../services/google_place/google_place_service.dart';
import '../themes/app_colors.dart';
import '../utils/app_logger.dart';

class AddressSuggestionListView extends StatelessWidget {
  final double? listHeight;
  final List locationList;
  final CancelToken? cancelToken;
  final void Function(GooglePlaceModel googlePlaceModel)? onTapPlace;

  const AddressSuggestionListView({
    super.key,
    this.listHeight,
    this.cancelToken,
    required this.locationList,
    this.onTapPlace,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: locationList.isEmpty ? 0 : listHeight,
      child: ListView.separated(
        shrinkWrap: true,
        primary: false,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: locationList.length,
        itemBuilder: (context, index) {
          return InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: () async {
              context.showLoading();

              logger.i("LOC ID: ${locationList[index]['place_id']}");

              GooglePlaceModel googlePlaceModel =
                  await GooglePlaceService.getPlaceDetails(
                placeId: locationList[index]['place_id'],
                cancelToken: cancelToken,
                setAsLocation: false,
              );

              if (googlePlaceModel.locationAddressFull.isNotEmpty) {
                onTapPlace?.call(googlePlaceModel);
              }
              context.hideLoading();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_rounded),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    locationList[index]['description'],
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(vertical: 8);
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
