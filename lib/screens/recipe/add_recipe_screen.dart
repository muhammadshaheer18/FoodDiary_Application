import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/recipe/recipe_bloc.dart';
import '../../bloc/recipe/recipe_event.dart';
import '../../models/recipe_model.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final imageUrlController = TextEditingController();
  final ratingController = TextEditingController();
  final cookTimeController = TextEditingController();
  final taglineController = TextEditingController();
  final servingsController = TextEditingController();

  // For category selection
  final List<String> _categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Appetizer',
    'Snack',
    'Beverage',
  ];
  String _selectedCategory = 'Dinner';

  // Sample image selection
  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
    'https://images.unsplash.com/photo-1565958011703-44f9829ba187',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
    'https://images.unsplash.com/photo-1473093295043-cdd812d0e601',
  ];
  String _selectedImage =
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c';

  double _rating = 4.5;

  @override
  void initState() {
    super.initState();
    categoryController.text = _selectedCategory;
    imageUrlController.text = _selectedImage;
    ratingController.text = _rating.toString();
    servingsController.text = '4';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final recipe = Recipe(
        id: '',
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: _selectedCategory,
        imageUrl: _selectedImage,
        rating: _rating,
        cookTime: cookTimeController.text.trim(),
        tagline: taglineController.text.trim(),
      );

      context.read<RecipeBloc>().add(AddRecipe(recipe));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe added successfully!'),
          backgroundColor: Color(0xFFFF9800),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define our yellow-orange theme colors
    const primaryColor = Color(0xFFFF9800); // Orange
    const accentColor = Color(0xFFFFB74D); // Light Orange
    const backgroundColor = Colors.white;
    const cardColor = Color(0xFFFFECB3); // Very Light Orange

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: accentColor,
          surface: cardColor,
          background: backgroundColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          title: const Text(
            "Create New Recipe",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Show confirmation dialog if form has been edited
              if (titleController.text.isNotEmpty ||
                  descriptionController.text.isNotEmpty ||
                  taglineController.text.isNotEmpty) {
                showDialog(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text("Discard changes?"),
                        content: const Text(
                          "You have unsaved changes that will be lost.",
                        ),
                        actions: [
                          TextButton(
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.grey),
                            ),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                          TextButton(
                            child: const Text(
                              "Discard",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Hero image section with selection
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      _selectedImage,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: accentColor.withOpacity(0.3),
                            child: const Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: FloatingActionButton(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        mini: true,
                        child: const Icon(Icons.photo_library),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder:
                                (ctx) => Container(
                                  height: 200,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Select Image",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _sampleImages.length,
                                          itemBuilder: (context, index) {
                                            final image = _sampleImages[index];
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedImage = image;
                                                  imageUrlController.text =
                                                      image;
                                                });
                                                Navigator.pop(ctx);
                                              },
                                              child: Container(
                                                width: 120,
                                                margin: const EdgeInsets.only(
                                                  right: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border:
                                                      image == _selectedImage
                                                          ? Border.all(
                                                            color: primaryColor,
                                                            width: 3,
                                                          )
                                                          : null,
                                                  image: DecorationImage(
                                                    image: NetworkImage(image),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Recipe Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: "Recipe Title",
                          prefixIcon: Icon(Icons.restaurant_menu),
                        ),
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Please enter a title'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      // Tagline
                      TextFormField(
                        controller: taglineController,
                        decoration: const InputDecoration(
                          labelText: "Tagline (short description)",
                          prefixIcon: Icon(Icons.short_text),
                        ),
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Please enter a tagline'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      DropdownButtonFormField(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: "Category",
                          prefixIcon: Icon(Icons.category),
                        ),
                        items:
                            _categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value as String;
                            categoryController.text = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Cook time and servings in a row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: cookTimeController,
                              decoration: const InputDecoration(
                                labelText: "Cook Time (mins)",
                                prefixIcon: Icon(Icons.timer),
                              ),
                              keyboardType: TextInputType.number,
                              validator:
                                  (val) =>
                                      val == null || val.isEmpty
                                          ? 'Required'
                                          : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: servingsController,
                              decoration: const InputDecoration(
                                labelText: "Servings",
                                prefixIcon: Icon(Icons.people),
                              ),
                              keyboardType: TextInputType.number,
                              validator:
                                  (val) =>
                                      val == null || val.isEmpty
                                          ? 'Required'
                                          : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Rating Slider
                      const Text(
                        "Rating",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Expanded(
                            child: Slider(
                              value: _rating,
                              min: 1.0,
                              max: 5.0,
                              divisions: 8,
                              activeColor: Colors.amber,
                              label: _rating.toString(),
                              onChanged: (value) {
                                setState(() {
                                  _rating = value;
                                  ratingController.text = value.toString();
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 48,
                            alignment: Alignment.center,
                            child: Text(
                              _rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          prefixIcon: Icon(Icons.description),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Please enter a description'
                                    : null,
                      ),

                      const SizedBox(height: 32),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.check_circle),
                          label: const Text(
                            "Add Recipe",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
