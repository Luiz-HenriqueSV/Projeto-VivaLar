class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double originalPrice;
  final int stock;
  final String thumbnail;
  final String image;
  final double rating;
  final int reviewCount;
  final String shortDescription;
  final String longDescription;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.stock,
    required this.thumbnail,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.shortDescription,
    required this.longDescription,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'].toString(),
        name: j['name'] as String? ?? '',
        category: j['category'] as String? ?? '',
        price: (j['price'] as num?)?.toDouble() ?? 0,
        originalPrice: (j['originalPrice'] as num?)?.toDouble() ?? 0,
        stock: (j['stock'] as num?)?.toInt() ?? 0,
        thumbnail: j['thumbnail'] as String? ?? '📦',
        image: j['image'] as String? ?? '',
        rating: (j['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: (j['reviewCount'] as num?)?.toInt() ?? 0,
        shortDescription: j['shortDescription'] as String? ?? '',
        longDescription: j['longDescription'] as String? ?? '',
      );

  int get discountPercent =>
      originalPrice > price ? ((1 - price / originalPrice) * 100).round() : 0;
}
