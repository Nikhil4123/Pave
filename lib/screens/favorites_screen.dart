import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/favorites_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('❤️ [FavoritesScreen] Building favorites screen...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer2<ProductsProvider, FavoritesProvider>(
        builder: (context, productsProvider, favoritesProvider, _) {
          final favoriteIds = favoritesProvider.favoriteIds;
          debugPrint('❤️ [FavoritesScreen] Favorite IDs: $favoriteIds');
          
          if (favoriteIds.isEmpty) {
            debugPrint('📭 [FavoritesScreen] No favorites found, showing empty state');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on any product to add it here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Filter products to show only favorites
          final favoriteProducts = productsProvider.products
              .where((product) => favoriteIds.contains(product.id))
              .toList();
          
          debugPrint('✅ [FavoritesScreen] Found ${favoriteProducts.length} favorite products');

          if (favoriteProducts.isEmpty) {
            debugPrint('⚠️ [FavoritesScreen] Favorite IDs exist but products not found in products list');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sync_problem,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Favorites not loaded',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please refresh the products list',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width ~/ 200 < 2 ? 2 : width ~/ 200;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];
                  debugPrint('🎴 [FavoritesScreen] Building card for favorite product ${product.id} (${product.title})');
                  return ProductCard(
                    product: product,
                    isFavorite: true,
                    onTap: () => _openDetail(context, product),
                    onToggleFavorite: () {
                      debugPrint('❤️ [FavoritesScreen] Removing favorite from favorites screen');
                      favoritesProvider.toggleFavorite(product.id);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, Product product) {
    debugPrint('🔍 [FavoritesScreen] Opening detail screen for product ${product.id} (${product.title})');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          debugPrint('📄 [FavoritesScreen] ProductDetailScreen created');
          return ProductDetailScreen(product: product);
        },
      ),
    );
  }
}

