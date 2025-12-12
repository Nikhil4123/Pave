class Product {
  final String id;
  final String title;
  final String imageUrl;

  const Product({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle id as either string or number (fakestoreapi uses numbers)
    final id = json['id']?.toString() ?? '';
    // Handle both 'imageUrl' (old format) and 'image' (fakestoreapi format)
    final imageUrl = json['imageUrl'] as String? ?? json['image'] as String? ?? '';
    
    return Product(
      id: id,
      title: json['title'] as String? ?? '',
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
    };
  }
}


