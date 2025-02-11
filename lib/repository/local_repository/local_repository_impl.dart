part of 'local_repository.dart';

class LocalRepositoryImpl extends LocalRepository {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<bool> setData(LocalStorageKey key, dynamic value) async {
    final SharedPreferences pref = await _prefs;
    // Save data based on type
    switch (value.runtimeType) {
      case const (String):
        return pref.setString(key.name, value as String);
      case const (int):
        return pref.setInt(key.name, value as int);
      case const (double):
        return pref.setDouble(key.name, value as double);
      case const (bool):
        return pref.setBool(key.name, value as bool);
      default:
        return pref.setString(key.name, value.toString());
    }
  }

  @override
  Future<dynamic> getData(LocalStorageKey key) async {
    final SharedPreferences pref = await _prefs;
    return pref.get(key.name);
  }

  @override
  Future<bool> clearSpecificKey(LocalStorageKey key) async {
    final SharedPreferences pref = await _prefs;
    return pref.remove(key.name);
  }

  @override
  Future<bool> setMapData(
    LocalStorageKey key,
    Map<String, dynamic> value,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(value);
    return await prefs.setString(key.name, jsonString);
  }

  @override
  Future<Map<String, dynamic>?> getMapData(LocalStorageKey key) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key.name);

    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearLoginData() async {
    clearSpecificKey(LocalStorageKey.bearerToken);
    clearSpecificKey(LocalStorageKey.userData);
  }

  /*@override
  Future<void> setLoginData({
    String? token,
    required UserModel user,
  }) async {
    setData(LocalStorageKey.userData, jsonEncode(user.toJson()));
    if (token != null && token.isNotEmpty) {
      setData(LocalStorageKey.bearerToken, token);
    }

    logger.i("UserModel stored locally: ${jsonEncode(user.toJson())}");
  }

  @override
  Future<UserModel?> getUserModel() async {
    String? data = await getData(LocalStorageKey.userData);
    if (data != null) {
      UserModel userModel = UserModel.fromJson(jsonDecode(data));
      logger.i("UserModel from local: ${jsonEncode(userModel.toJson())}");
      return userModel;
    }
    return null;
  }*/
}
