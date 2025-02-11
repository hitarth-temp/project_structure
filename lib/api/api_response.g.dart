// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      code: (json['code'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      jsonData: _$nullableGenericFromJson(json['data'], fromJsonT),
      status: json['status'] as bool? ?? false,
      bearerToken: json['bearer_token'] as String? ?? '',
      appStatus: $enumDecodeNullable(_$AppStatusEnumMap, json['update']) ??
          AppStatus.normal,
      links: json['links'] == null
          ? null
          : Links.fromJson(json['links'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'message': instance.message,
      'data': _$nullableGenericToJson(instance.jsonData, toJsonT),
      'bearer_token': instance.bearerToken,
      'update': _$AppStatusEnumMap[instance.appStatus]!,
      'links': instance.links,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

const _$AppStatusEnumMap = {
  AppStatus.optionalUpdate: 0,
  AppStatus.forceUpdate: 1,
  AppStatus.maintenance: 2,
  AppStatus.normal: 3,
};

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

Links _$LinksFromJson(Map<String, dynamic> json) => Links(
      first: json['first'] as String?,
      last: json['last'] as String?,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );

Map<String, dynamic> _$LinksToJson(Links instance) => <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
      'next': instance.next,
      'prev': instance.prev,
    };
