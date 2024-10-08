
import 'package:json_annotation/json_annotation.dart';

import 'hit_model.dart';

part 'image_response.g.dart';
@JsonSerializable()
class ImageResponse {
  final int total;
  final int totalHits;
  final List<Hits> hits;

  ImageResponse({required this.total, required this.totalHits, required this.hits});

  factory ImageResponse.fromJson(Map<String, dynamic> json) => _$ImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImageResponseToJson(this);

}