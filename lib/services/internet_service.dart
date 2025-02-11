import 'dart:async';

import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../core/utils/app_logger.dart';

class InternetService extends GetxController {
  RxBool hasConnection = true.obs;
  late final StreamSubscription<InternetConnectionStatus>
      _connectionSubscription;

  @override
  void onInit() {
    _startMonitoringInternet();
    super.onInit();
  }

  /// listen internet connectivity
  void _startMonitoringInternet() {
    _connectionSubscription = InternetConnectionChecker.instance.onStatusChange
        .listen((status) async {
      if (status == InternetConnectionStatus.disconnected &&
          hasConnection.value) {
        hasConnection.value = false;
        logger.log("Internet Disconnected");
      } else {
        logger.log("Internet Connected");
        hasConnection.value = true;
      }
    });
  }

  @override
  void onClose() {
    _connectionSubscription.cancel();
    super.onClose();
  }
}
