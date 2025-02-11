import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'api/api_client/api_client.dart';
import 'api/api_constant.dart';

import 'localization/app_localization_controller.dart';
import 'repository/local_repository/local_repository.dart';
import 'repository/remote_repository/remote_repository.dart';
import 'services/internet_service.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting();

  // App Orientation
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  initDependencies().whenComplete(
    () {
      runApp(const MyApp());
    },
  );
}

/// Initialize dependencies
Future<void> initDependencies() async {
  /// Local storage
  Get.put<LocalRepository>(LocalRepositoryImpl());

  /// Internet service
  Get.put(InternetService());

  /// Dio API Client
  Get.put<RemoteRepository>(
    RemoteRepositoryImpl(ApiClient.initApiClient(baseUrl: ApiConstant.baseUrl)),
  );

  Get.put(AppLocalizationController());
}
