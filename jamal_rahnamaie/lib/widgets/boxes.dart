import 'package:hive/hive.dart';
import 'package:jamal_rahnamaie/models/fav_model.dart';

class Boxes {
  static Box<FavModel> getHistory() => Hive.box<FavModel>('favBox');
}
