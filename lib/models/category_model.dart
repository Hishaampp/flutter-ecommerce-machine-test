class CategoryModel {
  final int id;
  final String slug;
  final String image;
  final String name;
  final String description;
  final int subcategoryCount;

  CategoryModel({
    required this.id,
    required this.slug,
    required this.image,
    required this.name,
    required this.description,
    required this.subcategoryCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] ?? {};
    final sub = json['subcategory'];

    return CategoryModel(
      id: category['id'] ?? 0,
      slug: category['slug']?.toString() ?? '',
      image: category['image']?.toString() ?? '',
      name: category['name']?.toString() ?? '',
      description: category['description']?.toString() ?? '',
      subcategoryCount: sub is List ? sub.length : 0,
    );
  }
}