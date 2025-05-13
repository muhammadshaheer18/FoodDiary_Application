import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/recipe/recipe_bloc.dart';
import '../../bloc/recipe/recipe_state.dart';
import '../recipe/recipe_detail_screen.dart';
import '../../bloc/recipe/recipe_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  // Function to toggle like status in Firestore
  Future<void> _toggleLike(String recipeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    final likedRecipesRef = userRef.collection('liked_recipes');

    // Check if the recipe is already liked by the user
    final docSnapshot = await likedRecipesRef.doc(recipeId).get();
    if (docSnapshot.exists) {
      // If liked, unlike it (delete from liked_recipes)
      await likedRecipesRef.doc(recipeId).delete();
    } else {
      // If not liked, like it (add to liked_recipes)
      await likedRecipesRef.doc(recipeId).set({});
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF9800);
    const accentColor = Color(0xFFFFB74D);
    const backgroundColor = Colors.white;
    const cardColor = Color(0xFFFFECB3);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: accentColor,
          surface: cardColor,
          background: backgroundColor,
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          title: const Text(
            "My Recipe Collection",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: IconButton(
                icon: const Icon(Icons.add_circle, size: 30),
                onPressed: () => Navigator.pushNamed(context, '/add-recipe'),
              ),
            ),
          ],
        ),
        body: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            } else if (state is RecipeLoaded) {
              final recipes = state.recipes;

              if (recipes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 80,
                        color: primaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "No recipes found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text("Add Your First Recipe"),
                        onPressed:
                            () => Navigator.pushNamed(context, '/add-recipe'),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Material(
                            color: cardColor,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            RecipeDetailScreen(recipe: recipe),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Image.network(
                                        recipe.imageUrl,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, _, __) => Container(
                                              height: 180,
                                              color: accentColor.withOpacity(
                                                0.3,
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(16),
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          child: Text(
                                            recipe.category,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                recipe.title,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.timer,
                                                    size: 16,
                                                    color: primaryColor,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "${recipe.cookTime} mins",
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  const Icon(
                                                    Icons.restaurant,
                                                    size: 16,
                                                    color: primaryColor,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: IconButton(
                                            icon: StreamBuilder<
                                              DocumentSnapshot
                                            >(
                                              stream:
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(
                                                        FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid,
                                                      )
                                                      .collection(
                                                        'liked_recipes',
                                                      )
                                                      .doc(recipe.id)
                                                      .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.pinkAccent,
                                                  );
                                                }

                                                final liked =
                                                    snapshot.data?.exists ??
                                                    false;
                                                return Icon(
                                                  liked
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color:
                                                      liked
                                                          ? Colors.pinkAccent
                                                          : Colors.pinkAccent,
                                                );
                                              },
                                            ),
                                            onPressed: () {
                                              _toggleLike(recipe.id);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is RecipeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.read<RecipeBloc>().add(LoadRecipes());
                      },
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(context, '/add-recipe'),
        ),
      ),
    );
  }
}
