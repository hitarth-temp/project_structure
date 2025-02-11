import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api_constant.dart';
import '../api_response.dart';
import 'api_interceptor.dart';

part 'api_client.g.dart';


@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  /// initialize api client [SHOULD BE CALLED ONCE BEFORE USE `ApiClient`]
  static ApiClient initApiClient({String? baseUrl}) {
    Dio dio = Dio(BaseOptions(
        baseUrl: (baseUrl ?? ApiConstant.baseUrl) + ApiConstant.api))
      ..interceptors.add(ApiInterceptor());

    // Pass the Dio instance with the base URL to ApiClient
    return ApiClient(dio);
  }

  @GET('${ApiConstant.init}/{version}/{device}')
  Future<ApiResponse> initApi({
    @Path('version') String? version,
    @Path('device') String? device,
  });

  @GET("get_language")
  Future<ApiResponse> getLanguages();
}
