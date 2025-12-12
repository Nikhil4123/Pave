import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _prefsKey = 'favoriteIds';

  final Set<String> _favoriteIds = <String>{};
  bool _isLoaded = false;

  Set<String> get favoriteIds => _favoriteIds;
  bool get isLoaded => _isLoaded;

  Future<void> loadFavorites() async {
    debugPrint('❤️ [FavoritesProvider] Loading favorites from SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefsKey);
    if (saved != null) {
      _favoriteIds
        ..clear()
        ..addAll(saved);
      debugPrint('✅ [FavoritesProvider] Loaded ${_favoriteIds.length} favorites: $_favoriteIds');
    } else {
      debugPrint('📭 [FavoritesProvider] No saved favorites found');
    }
    _isLoaded = true;
    notifyListeners();
  }

  bool isFavorite(String productId) {
    final result = _favoriteIds.contains(productId);
    debugPrint('❤️ [FavoritesProvider] Checking favorite status for product $productId: $result');
    return result;
  }

  Future<void> toggleFavorite(String productId) async {
    final wasFavorite = _favoriteIds.contains(productId);
    if (wasFavorite) {
      _favoriteIds.remove(productId);
      debugPrint('➖ [FavoritesProvider] Removed product $productId from favorites');
    } else {
      _favoriteIds.add(productId);
      debugPrint('➕ [FavoritesProvider] Added product $productId to favorites');
    }
    notifyListeners();
    debugPrint('💾 [FavoritesProvider] Saving favorites to SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _favoriteIds.toList());
    debugPrint('✅ [FavoritesProvider] Saved ${_favoriteIds.length} favorites: $_favoriteIds');
  }
}


