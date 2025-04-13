class Product_Model {
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;

  Product_Model({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
  });

  factory Product_Model.fromJson(Map<String, dynamic> json) {
    return Product_Model(
      id: json['id'] ?? 0,
      name: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['thumbnail'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'description': description,
      'thumbnail': image,
      'price': price,
    };
  }
}
