import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/favorites_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    debugPrint('📄 [ProductDetailScreen] Building detail screen for product ${product.id} (${product.title})');
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favorites, _) {
              final isFavorite = favorites.isFavorite(product.id);
              debugPrint('❤️ [ProductDetailScreen] AppBar favorite button - isFavorite: $isFavorite');
              return IconButton(
                tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  debugPrint('❤️ [ProductDetailScreen] AppBar favorite button pressed for product ${product.id}');
                  favorites.toggleFavorite(product.id);
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'product-image-${product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) {
                          debugPrint('✅ [ProductDetailScreen] Image loaded successfully');
                          return child;
                        }
                        debugPrint('⏳ [ProductDetailScreen] Loading image: ${progress.cumulativeBytesLoaded}/${progress.expectedTotalBytes} bytes');
                        return Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (_, __, ___) {
                        debugPrint('❌ [ProductDetailScreen] Image failed to load for product ${product.id}');
                        return Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image_outlined),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                product.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Consumer<FavoritesProvider>(
                builder: (context, favorites, _) {
                  final isFavorite = favorites.isFavorite(product.id);
                  debugPrint('❤️ [ProductDetailScreen] Favorite button - isFavorite: $isFavorite');
                  return FilledButton.icon(
                    onPressed: () {
                      debugPrint('❤️ [ProductDetailScreen] Favorite button pressed for product ${product.id}');
                      favorites.toggleFavorite(product.id);
                    },
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                    label: Text(isFavorite ? 'Added to Favorites' : 'Add to Favorites'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


