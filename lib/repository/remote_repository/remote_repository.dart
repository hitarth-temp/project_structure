import 'package:package_info_plus/package_info_plus.dart';
import '../../api/api_client/api_client.dart';

import '../../api/api_response.dart';

part 'remote_repository_impl.dart';

abstract class RemoteRepository {
  Future<ApiResponse> initApi();
}
