class Recipe {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final String cookTime;
  final String tagline;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.cookTime,
    required this.tagline,
  });

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? imageUrl,
    double? rating,
    String? cookTime,
    String? tagline,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      cookTime: cookTime ?? this.cookTime,
      tagline: tagline ?? this.tagline,
    );
  }

  factory Recipe.fromMap(Map<String, dynamic> data, String id) {
    return Recipe(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      rating:
          (data['rating'] is int)
              ? (data['rating'] as int).toDouble()
              : (data['rating'] ?? 5.0).toDouble(),
      cookTime: data['cookTime'] ?? '',
      tagline: data['tagline'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'rating': rating,
      'cookTime': cookTime,
      'tagline': tagline,
    };
  }
}
