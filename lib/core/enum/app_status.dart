import 'package:json_annotation/json_annotation.dart';

enum AppStatus {
  @JsonValue(0)
  optionalUpdate,
  @JsonValue(1)
  forceUpdate,
  @JsonValue(2)
  maintenance,
  @JsonValue(3)
  normal,
}
