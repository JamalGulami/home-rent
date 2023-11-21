import 'package:hive/hive.dart';

part 'fav_model.g.dart'; // Make sure to include this part statement.

@HiveType(typeId: 0)
class FavModel {
  @HiveField(0)
  final String productId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final String imageUrl;

  FavModel({
    required this.productId,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
  });
}
