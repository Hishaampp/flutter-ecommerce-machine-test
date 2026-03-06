class ProductModel {
  final String slug;
  final String name;
  final String store;
  final String manufacturer;
  final String symbolLeft;
  final String oldPrice;
  final String price;
  final String image;
  final String discount;

  ProductModel({
    required this.slug,
    required this.name,
    required this.store,
    required this.manufacturer,
    required this.symbolLeft,
    required this.oldPrice,
    required this.price,
    required this.image,
    required this.discount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      store: json['store']?.toString() ?? '',
      manufacturer: json['manufacturer']?.toString() ?? '',
      symbolLeft: json['symbol_left']?.toString() ?? '',
      oldPrice: json['oldprice']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      discount: json['discount']?.toString() ?? '',
    );
  }

  bool get hasDiscount => oldPrice != price && oldPrice.isNotEmpty;
}