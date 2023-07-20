class Product {
  final String id;
  final String title;
  final String description;
  final String email;
  final String image;
  final String name;
  final String type;
  bool isVerified;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.email,
    required this.name,
    required this.image,
    required this.type,
    this.isVerified = false,
  });

  void toggleFavorite() {
    isVerified = !isVerified;
  }
}
