import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductsProvider extends ChangeNotifier {
  ProductsProvider({ProductService? service})
      : _service = service ?? ProductService();

  final ProductService _service;

  bool _isLoading = false;
  String? _errorMessage;
  List<Product> _products = <Product>[];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Product> get products => _products;

  Future<void> loadProducts() async {
    debugPrint('🔄 [ProductsProvider] Starting to load products...');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _products = await _service.fetchProducts();
      debugPrint('✅ [ProductsProvider] Products loaded successfully: ${_products.length} items');
    } catch (e) {
      debugPrint('❌ [ProductsProvider] Error loading products: $e');
      _errorMessage = 'Unable to load products.';
      _products = <Product>[];
    } finally {
      _isLoading = false;
      debugPrint('🏁 [ProductsProvider] Loading completed. isLoading: $_isLoading, products count: ${_products.length}');
      notifyListeners();
    }
  }
}


