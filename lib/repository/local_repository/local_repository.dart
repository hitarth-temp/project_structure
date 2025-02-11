import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

part 'local_repository_impl.dart';

part 'local_storage_key.dart';

abstract class LocalRepository {
  /// Save data
  Future<bool> setData(LocalStorageKey key, dynamic value);

  /// Get data
  Future<dynamic> getData(LocalStorageKey key);

  /// Clear all data
  Future<void> clearLoginData();

  /// Clear specific data
  Future<bool> clearSpecificKey(LocalStorageKey key);

  /// Save Map data
  Future<bool> setMapData(LocalStorageKey key, Map<String, dynamic> value);

  /// Get Map data
  Future<Map<String, dynamic>?> getMapData(LocalStorageKey key);

  /// set login data
// Future<void> setLoginData({String? token, required UserModel user});

  /// get user model
// Future<UserModel?> getUserModel();
}
