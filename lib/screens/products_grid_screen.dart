import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/favorites_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';
import 'favorites_screen.dart';
import 'product_detail_screen.dart';

class ProductsGridScreen extends StatefulWidget {
  const ProductsGridScreen({super.key});

  @override
  State<ProductsGridScreen> createState() => _ProductsGridScreenState();
}

class _ProductsGridScreenState extends State<ProductsGridScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('📱 [ProductsGridScreen] Initializing screen...');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('📱 [ProductsGridScreen] Post-frame callback executing...');
      final favorites = context.read<FavoritesProvider>();
      if (!favorites.isLoaded) {
        debugPrint('❤️ [ProductsGridScreen] Loading favorites...');
        favorites.loadFavorites();
      } else {
        debugPrint('❤️ [ProductsGridScreen] Favorites already loaded');
      }
      final products = context.read<ProductsProvider>();
      if (products.products.isEmpty && !products.isLoading) {
        debugPrint('📦 [ProductsGridScreen] Loading products...');
        products.loadProducts();
      } else {
        debugPrint('📦 [ProductsGridScreen] Products state: ${products.products.length} items, loading: ${products.isLoading}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favorites, _) {
              final favoriteCount = favorites.favoriteIds.length;
              debugPrint('❤️ [ProductsGridScreen] AppBar - Favorite count: $favoriteCount');
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    tooltip: 'View Favorites',
                    onPressed: () {
                      debugPrint('❤️ [ProductsGridScreen] Favorites button pressed, navigating to FavoritesScreen');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            debugPrint('📄 [ProductsGridScreen] FavoritesScreen created');
                            return const FavoritesScreen();
                          },
                        ),
                      );
                    },
                  ),
                  if (favoriteCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          favoriteCount > 9 ? '9+' : favoriteCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer2<ProductsProvider, FavoritesProvider>(
        builder: (context, products, favorites, _) {
          debugPrint('🔄 [ProductsGridScreen] Rebuilding UI - Products: ${products.products.length}, Loading: ${products.isLoading}, Error: ${products.errorMessage}');
          
          if (products.isLoading && products.products.isEmpty) {
            debugPrint('⏳ [ProductsGridScreen] Showing loading indicator');
            return const Center(child: CircularProgressIndicator());
          }

          if (products.errorMessage != null && products.products.isEmpty) {
            debugPrint('❌ [ProductsGridScreen] Showing error state: ${products.errorMessage}');
            return _ErrorState(
              message: products.errorMessage!,
              onRetry: products.loadProducts,
            );
          }

          if (products.products.isEmpty) {
            debugPrint('📭 [ProductsGridScreen] Showing empty state');
            return const Center(child: Text('No products available right now.'));
          }

          return RefreshIndicator(
            onRefresh: products.loadProducts,
            child: LayoutBuilder(
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
                  itemCount: products.products.length,
                  itemBuilder: (context, index) {
                    final product = products.products[index];
                    final isFavorite = favorites.isFavorite(product.id);
                    debugPrint('🎴 [ProductsGridScreen] Building card for product ${product.id} (${product.title}), favorite: $isFavorite');
                    return ProductCard(
                      product: product,
                      isFavorite: isFavorite,
                      onTap: () => _openDetail(context, product),
                      onToggleFavorite: () => favorites.toggleFavorite(product.id),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, Product product) {
    debugPrint('🔍 [ProductsGridScreen] Opening detail screen for product ${product.id} (${product.title})');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          debugPrint('📄 [ProductsGridScreen] ProductDetailScreen created');
          return ProductDetailScreen(product: product);
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}


