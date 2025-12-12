import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  ProductService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _endpoint = 'https://fakestoreapi.com/products';
  static const _fallbackAssetPath = 'assets/products_fallback.json';

  Future<List<Product>> fetchProducts() async {
    debugPrint('🌐 [ProductService] Fetching products from API: $_endpoint');
    try {
      final response = await _client
          .get(Uri.parse(_endpoint))
          .timeout(const Duration(seconds: 10));
      debugPrint('📡 [ProductService] API response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as List<dynamic>;
        final products = body.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
        debugPrint('✅ [ProductService] Successfully fetched ${products.length} products from API');
        return products;
      } else {
        debugPrint('⚠️ [ProductService] API returned status ${response.statusCode}, falling back to local JSON');
      }
    } catch (e) {
      debugPrint('❌ [ProductService] API request failed: $e');
      debugPrint('📦 [ProductService] Falling back to local asset: $_fallbackAssetPath');
    }

    debugPrint('📂 [ProductService] Loading fallback JSON from assets...');
    final fallbackJson = await rootBundle.loadString(_fallbackAssetPath);
    final fallbackList = jsonDecode(fallbackJson) as List<dynamic>;
    final products = fallbackList.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
    debugPrint('✅ [ProductService] Loaded ${products.length} products from fallback JSON');
    return products;
  }
}


