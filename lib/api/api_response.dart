import 'package:json_annotation/json_annotation.dart';

import '../core/enum/app_status.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  @JsonKey(name: "code")
  final int code;
  @JsonKey(name: "status")
  final bool status;
  @JsonKey(name: "message", defaultValue: "")
  final String message;
  @JsonKey(name: "data")
  final T? jsonData;
  @JsonKey(
    name: "bearer_token",
    defaultValue: "",
  )
  final String bearerToken;

  @JsonKey(name: "update")
  final AppStatus appStatus;

  @JsonKey(name: "links")
  final Links? links;

  ApiResponse({
    this.code = 0,
    this.message = "",
    this.jsonData,
    this.status = false,
    this.bearerToken = "",
    this.appStatus = AppStatus.normal,
    this.links,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

@JsonSerializable()
class Links {
  @JsonKey(name: "first")
  String? first;
  @JsonKey(name: "last")
  String? last;
  @JsonKey(name: "next")
  String? next;
  @JsonKey(name: "prev")
  String? prev;

  Links({
    this.first,
    this.last,
    this.next,
    this.prev,
  });

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}