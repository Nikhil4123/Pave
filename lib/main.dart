import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'providers/products_provider.dart';
import 'screens/products_grid_screen.dart';

void main() {
  debugPrint('🚀 [MAIN] App starting...');
  runApp(const PaveProductsApp());
}

class PaveProductsApp extends StatelessWidget {
  const PaveProductsApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('📱 [PaveProductsApp] Building app with providers...');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            debugPrint('📦 [PaveProductsApp] Creating ProductsProvider...');
            return ProductsProvider()..loadProducts();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            debugPrint('❤️ [PaveProductsApp] Creating FavoritesProvider...');
            return FavoritesProvider()..loadFavorites();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Product Viewer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const ProductsGridScreen(),
      ),
    );
  }
}
