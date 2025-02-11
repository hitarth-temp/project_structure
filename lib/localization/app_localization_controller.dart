import 'dart:ui';

import 'package:get/get.dart';

import '../api/api_response.dart';
import '../core/utils/app_logger.dart';

import '../core/utils/dialog_utils.dart';
import '../repository/local_repository/local_repository.dart';
import '../repository/remote_repository/remote_repository.dart';
import '../services/internet_service.dart';
import 'localization.dart';

class AppLocalizationController extends GetxService {
  final _localRepository = Get.find<LocalRepository>();
  final _remoteRepository = Get.find<RemoteRepository>();

  Future<void> changeAppLanguage({required Locale locale}) async {
    await _localRepository.setData(LocalStorageKey.languageCode, locale);
    Get.updateLocale(locale);
  }

  /// Get languages API
  Future<void> callGetLanguagesApi({
    required Locale locale,
    bool showFailureSnackbar = true,
  }) async {
    try {
      if (Get.find<InternetService>().hasConnection.value) {
        await _localRepository.setData(LocalStorageKey.languageCode, locale);
      }

      var response = ApiResponse(status: true); // todo: replace with api call

      if (response.status && response.jsonData is Map) {
        _applyTranslations(response.jsonData);

        // set strings map in local storage
        await _localRepository.setMapData(
          LocalStorageKey.appTranslationsMap,
          AppTranslation.translations,
        );
      } else {
        // get strings map from local storage
        Map<String, dynamic>? localTranslationMap = await _localRepository
            .getMapData(LocalStorageKey.appTranslationsMap);
        if (localTranslationMap != null && localTranslationMap.isNotEmpty) {
          _applyTranslations(localTranslationMap[Get.locale!.languageCode]);
        }

        if (showFailureSnackbar) {
          DialogUtils.showSnackBar(
            response.message,
            snackbarType: SnackbarType.failure,
          );
        }
      }

      logger.i("callGetLanguagesApi done:");
    } catch (e) {
      logger.e("callGetLanguagesApi: $e");
    }
  }

  /// Load strings dynamically
  Future<void> _applyTranslations(
    Map<String, dynamic> languageResponseMap,
  ) async {
    String langCode =
        await _localRepository.getData(LocalStorageKey.languageCode) ??
            AppTranslation.fallbackLocale.languageCode;

    // remove null or empty values
    languageResponseMap.removeWhere(
      (key, value) => value == null || value == "",
    );

    Get.clearTranslations();

    AppTranslation.translations[langCode] =
        Map<String, String>.from(languageResponseMap);

    Get.addTranslations(AppTranslation.translations);

    Get.updateLocale(Locale(langCode));
  }
}
