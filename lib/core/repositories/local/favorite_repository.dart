import 'package:example/core/models/models.dart';
import 'package:example/core/providers/providers.dart';

class FavoriteRepository {
  FavoriteProvider _favoriteProvider = new FavoriteProvider();

  Future<bool> updateFavoriteToSF(List<People> peoples) =>
      _favoriteProvider.updateFavoriteToSF(peoples);

  Future<List<People>> getFavoriteFromSF() =>
      _favoriteProvider.getFavoriteFromSF();
}
