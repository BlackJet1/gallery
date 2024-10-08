import 'package:json_annotation/json_annotation.dart';
part 'hit_model.g.dart';
@JsonSerializable()
class Hits {
  final int? id;
  final String? pageURL;
  final String? type;
  final String?tags;
  final String? previewURL;
  final int? previewWidth;
  final int? previewHeight;
  final String? webformatURL;
  final int? webformatWidth;
  final int? webformatHeight;
  final String?largeImageURL;
  final int? imageWidth;
  final int? imageHeight;
  final int? imageSize;
  final int? views;
  final int? downloads;
  final int? favorites;
  final int? likes;
  final int? comments;
  final int? userId;
  final String? user;
  final String? userImageURL;

  Hits({
    this.id,
    this.pageURL,
    this.type,
    this.tags,
    this.previewURL,
    this.previewWidth,
    this.previewHeight,
    this.webformatURL,
    this.webformatWidth,
    this.webformatHeight,
    this.largeImageURL,
    this.imageWidth,
    this.imageHeight,
    this.imageSize,
    this.views,
    this.downloads,
    this.favorites,
    this.likes,
    this.comments,
    this.userId,
    this.user,
    this.userImageURL
  });

  factory Hits.fromJson(Map<String, dynamic> json) => _$HitsFromJson(json);

  Map<String, dynamic> toJson() => _$HitsToJson(this);

}