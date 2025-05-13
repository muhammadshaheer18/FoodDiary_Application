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

  // Expanded image selection options
  final List<String> _breakfastImages = [
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Avocado toast
    'https://images.unsplash.com/photo-1550583724-b2692b85b150?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Pancakes
    'https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Omelette
    'https://images.unsplash.com/photo-1484723091739-30a097e8f929?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // French toast
    'https://images.unsplash.com/photo-1509440159596-0249088772ff?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Yogurt bowl
  ];

  final List<String> _mainCourseImages = [
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Pizza
    'https://images.unsplash.com/photo-1565958011703-44f9829ba187?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Burger
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Salad
    'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Pasta
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Steak
    'https://images.unsplash.com/photo-1544025162-d76694265947?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Ramen
    'https://images.unsplash.com/photo-1518779578993-ec3579fee39f?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Sushi
    'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Tacos
  ];

  final List<String> _dessertImages = [
    'https://images.unsplash.com/photo-1563805042-7684c019e1cb?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Donuts
    'https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Ice cream
    'https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Chocolate cake
    'https://images.unsplash.com/photo-1519671482749-fd09be7ccebf?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Macarons
    'https://images.unsplash.com/photo-1603532648955-039310d9ed75?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Cheesecake
  ];

  final List<String> _healthyImages = [
    'https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Smoothie bowl
    'https://images.unsplash.com/photo-1543351611-58f69d7c1781?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Buddha bowl
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Veggie salad
    'https://images.unsplash.com/photo-1546069901-d5bfd2cbfb1f?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Fruit platter
  ];

  final List<String> _beverageImages = [
    'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Coffee
    'https://images.unsplash.com/photo-1551029506-0807df4e2031?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Smoothie
    'https://images.unsplash.com/photo-1558160074-4d7d8bdf4256?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Cocktail
    'https://images.unsplash.com/photo-1437418747212-8d9709afab22?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Tea
    'https://images.unsplash.com/photo-1551269901-5c5e14c25df7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80', // Juice
  ];

  String _selectedImage =
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
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
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    }
  }

  Widget _buildImageGrid(List<String> images) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedImage = image;
              imageUrlController.text = image;
            });
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:
                  image == _selectedImage
                      ? Border.all(color: const Color(0xFFFF9800), width: 3)
                      : null,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImageSelectionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (ctx) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: DefaultTabController(
              length: 5,
              child: Column(
                children: [
                  const TabBar(
                    isScrollable: true,
                    labelColor: Color(0xFFFF9800),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color(0xFFFF9800),
                    tabs: [
                      Tab(text: 'Breakfast'),
                      Tab(text: 'Main Courses'),
                      Tab(text: 'Desserts'),
                      Tab(text: 'Healthy'),
                      Tab(text: 'Beverages'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildImageGrid(_breakfastImages),
                        _buildImageGrid(_mainCourseImages),
                        _buildImageGrid(_dessertImages),
                        _buildImageGrid(_healthyImages),
                        _buildImageGrid(_beverageImages),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement upload functionality
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Upload Your Own Image'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF9800);
    const backgroundColor = Colors.white;
    const cardColor = Color(0xFFFFECB3);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: const Color(0xFFFFB74D),
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
                height: 220,
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
                            color: const Color(0xFFFFB74D).withOpacity(0.3),
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
                        onPressed: _showImageSelectionDialog,
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
