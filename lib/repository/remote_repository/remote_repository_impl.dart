part of 'remote_repository.dart';

class RemoteRepositoryImpl extends RemoteRepository {
  final ApiClient _apiClient;

  RemoteRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse> initApi() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      return await _apiClient.initApi(
        device: "",
        version: packageInfo.version,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse> getLanguages() async {
    try {
      return await _apiClient.getLanguages();
    } catch (e) {
      rethrow;
    }
  }
}
