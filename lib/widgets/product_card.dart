import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _pressed = false;

  void _handleTapDown(TapDownDetails details) {
    debugPrint('👆 [ProductCard] Tap down on product ${widget.product.id}');
    setState(() {
      _pressed = true;
    });
  }

  void _handleTapEnd([TapUpDetails? details]) {
    debugPrint('👆 [ProductCard] Tap end on product ${widget.product.id}');
    setState(() {
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      scale: _pressed ? 0.98 : 1,
      child: Card(
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            debugPrint('👆 [ProductCard] Card tapped for product ${widget.product.id} (${widget.product.title})');
            widget.onTap();
          },
          onTapDown: _handleTapDown,
          onTapUp: _handleTapEnd,
          onTapCancel: _handleTapEnd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: 'product-image-${widget.product.id}',
                        child: Image.network(
                          widget.product.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) {
                              debugPrint('✅ [ProductCard] Image loaded for product ${widget.product.id}');
                              return child;
                            }
                            debugPrint('⏳ [ProductCard] Loading image for product ${widget.product.id}: ${progress.cumulativeBytesLoaded}/${progress.expectedTotalBytes} bytes');
                            return Container(
                              color: Colors.grey.shade200,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (_, __, ___) {
                            debugPrint('❌ [ProductCard] Image failed to load for product ${widget.product.id}');
                            return Container(
                              color: Colors.grey.shade200,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image_outlined),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.black45,
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                            child: Icon(
                              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey<bool>(widget.isFavorite),
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            debugPrint('❤️ [ProductCard] Favorite button pressed for product ${widget.product.id}, current state: ${widget.isFavorite}');
                            widget.onToggleFavorite();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  widget.product.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


