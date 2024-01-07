import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<String> _favoritePokemonIds = [];
  bool _isLoaded = false;
  static const String _favoriteKey = 'favoritePokemonIds';
  List<String> get favoritePokemonIds => _favoritePokemonIds;

  bool isFavoriteForPokemon(String pokemonId) {
    return _favoritePokemonIds.contains(pokemonId);
  }

  Future<void> loadFavoritePokemonIds() async {
    if (!_isLoaded) {
      final prefs = await SharedPreferences.getInstance();
      _favoritePokemonIds.clear();
      _favoritePokemonIds.addAll(prefs.getStringList('favoritePokemonIds') ?? []);
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> updateFavoriteStateForPokemon(
      String pokemonId, bool newFavoriteState) async {
    if (newFavoriteState) {
      _favoritePokemonIds.add(pokemonId);
    } else {
      _favoritePokemonIds.remove(pokemonId);
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_favoriteKey, _favoritePokemonIds);

    notifyListeners();
  }

  void updateFavoriteStatePage(String pokemonId, bool newFavoriteState) {
    if (newFavoriteState) {
      if (!_favoritePokemonIds.contains(pokemonId)) {
        _favoritePokemonIds.add(pokemonId);
      }
    } else {
      _favoritePokemonIds.remove(pokemonId);
    }

    notifyListeners();
  }
}