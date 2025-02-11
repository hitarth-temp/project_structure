import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_x;

import '../../core/utils/app_logger.dart';
import '../../localization/app_strings.dart';
import '../../localization/localization.dart';
import '../../repository/local_repository/local_repository.dart';

class ApiInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final method = options.method;
    final uri = options.uri;
    final data = options.data;

    final localRepository = get_x.Get.find<LocalRepository>();

    String? token = await localRepository.getData(LocalStorageKey.bearerToken);
    String? lang =
        await localRepository.getData(LocalStorageKey.languageCode) ??
            AppTranslation.fallbackLocale.languageCode;

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
    }

    options.headers['Accept'] = 'application/json';
    options.headers['Accept-Language'] = lang;

    try {
      logger.log(
        "✈️ REQUEST[$method] => PATH: $uri \n Token:${options.headers} \n DATA: ${jsonEncode(data)}",
      );
    } catch (e) {
      logger.log(
        "✈️ REQUEST[$method] => PATH: $uri \n Token: ${options.headers} \n DATA: ${data.files.toString()}",
      );
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final statusCode = response.statusCode;
    final uri = response.requestOptions.uri;
    final data = jsonEncode(response.data);
    logger.log("✅ RESPONSE[$statusCode] => PATH: $uri\n DATA: $data");

    // Todo: Handle session expired

    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode!;
    final uri = err.requestOptions.path;
    var data = "";
    try {
      data = jsonEncode(err.response!.data);
    } catch (e) {
      logger.log(e.toString());
    }
    logger.log("⚠️ ERROR[$statusCode] => PATH: $uri\n DATA: $data");

    // Unauthenticated
    if (statusCode == 401) {
      await get_x.Get.find<LocalRepository>().clearLoginData();

      // todo: navigation after logout

      return handler.resolve(
        Response(
          data: {
            'success': false,
            'message': AppStrings.sessionExpiredLoginAgain.tr,
          },
          statusCode: 401,
          requestOptions: err.requestOptions,
        ),
      );
    }
    super.onError(err, handler);
  }
}
