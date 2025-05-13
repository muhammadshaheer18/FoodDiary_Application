// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    const primaryColor = Color(0xFFF5A623); // Yellow color
    const accentColor = Color(0xFFFFFACD); // Light yellow
    const backgroundColor = Colors.white; // White background
    const textColor = Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Color(0xFFF5A623),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'My Profile',
                style: GoogleFonts.playfairDisplay(
                  color: const Color.fromARGB(221, 255, 255, 255),
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor.withOpacity(0.8),
                      primaryColor.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  // Profile Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: accentColor,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // User Email
                  Text(
                    user?.email ?? "No Email Found",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Profile Options
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        _buildProfileOption(
                          context,
                          icon: Icons.email,
                          title: "Contact Admin: shaheer@gmail.com",
                          onTap: () {},
                          showArrow: false,
                        ),
                        const Divider(height: 1, color: Colors.grey),
                        _buildProfileOption(
                          context,
                          icon: Icons.privacy_tip_outlined,
                          title: "Privacy Policy",
                          onTap: () => _showPrivacyPolicy(context),
                          showArrow: false,
                        ),
                        const Divider(height: 1, color: Colors.grey),
                        _buildProfileOption(
                          context,
                          icon: Icons.favorite,
                          title: "Liked Recipes",
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LikedRecipesScreen(),
                                ),
                              ),
                          showArrow: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _signOut(context),
                      icon: const Icon(Icons.logout),
                      label: Text(
                        "Logout",
                        style: GoogleFonts.carroisGothic(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5A623),
                        foregroundColor: const Color.fromRGBO(0, 0, 0, 0.867),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Privacy Policy',
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                '1. This app collects basic user information for authentication purposes.\n\n'
                '2. Your email address is stored securely and will not be shared with third parties.\n\n'
                '3. Liked recipes are stored in your personal account and visible only to you.\n\n'
                '4. For any complaints or concerns, please contact the admin at shaheer@gmail.com.\n\n'
                '5. By using this app, you agree to these terms and conditions.',
                style: GoogleFonts.carroisGothic(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: GoogleFonts.carroisGothic(
                    color: const Color(0xFFF5A623),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFFF5A623), size: 28),
      title: Text(
        title,
        style: GoogleFonts.carroisGothic(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing:
          onTap != null && showArrow
              ? const Icon(Icons.arrow_forward_ios, size: 16)
              : null,
    );
  }
}

class LikedRecipesScreen extends StatelessWidget {
  const LikedRecipesScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchLikedRecipes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final likedRecipesSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('liked_recipes')
              .get();

      final recipeFutures =
          likedRecipesSnapshot.docs.map((doc) async {
            final recipeDoc =
                await FirebaseFirestore.instance
                    .collection('recipes')
                    .doc(doc.id)
                    .get();

            if (recipeDoc.exists) {
              return {
                'id': doc.id,
                'title': recipeDoc['title'] ?? 'Untitled Recipe',
                'category': recipeDoc['category'] ?? 'No Category',
                'imageUrl': recipeDoc['imageUrl'] ?? '',
              };
            }
            return null;
          }).toList();

      final recipes = await Future.wait(recipeFutures);
      return recipes.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      debugPrint('Error fetching liked recipes: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF5A623); // Yellow color
    const backgroundColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: Color(0xFFF5A623),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Liked Recipes',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFF5A623).withOpacity(0.8),
                      primaryColor.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchLikedRecipes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF5A623),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Failed to load recipes',
                        style: GoogleFonts.carroisGothic(),
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: const Color(0xFFF5A623).withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No liked recipes yet',
                            style: GoogleFonts.carroisGothic(
                              fontSize: 16,
                              color: Colors.black87.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final likedRecipes = snapshot.data!;
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final recipe = likedRecipes[index];
                    return _buildRecipeCard(context, recipe);
                  }, childCount: likedRecipes.length),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Map<String, dynamic> recipe) {
    const primaryColor = Color(0xFFF5A623);
    const backgroundColor = Colors.white;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: const Color(0xFFF5A623).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Recipe Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  recipe['imageUrl']?.isNotEmpty == true
                      ? Image.network(
                        recipe['imageUrl'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 80,
                              height: 80,
                              color: const Color(0xFFF5A623).withOpacity(0.1),
                              child: Icon(
                                Icons.restaurant,
                                color: const Color(0xFFF5A623),
                              ),
                            ),
                      )
                      : Container(
                        width: 80,
                        height: 80,
                        color: primaryColor.withOpacity(0.1),
                        child: Icon(Icons.restaurant, color: primaryColor),
                      ),
            ),
            const SizedBox(width: 16),
            // Recipe Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['title'],
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe['category'],
                    style: GoogleFonts.carroisGothic(
                      fontSize: 14,
                      color: Colors.black87.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
