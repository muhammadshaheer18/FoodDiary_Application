import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    const primaryColor = Color(0xFF3A3042);
    const accentColor = Color(0xFFBF9D7E);
    const backgroundColor = Color(0xFFF9F5F0);
    const textColor = Color(0xFF2F2235);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'My Profile',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
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
                      border: Border.all(color: accentColor, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: accentColor.withOpacity(0.2),
                      child: Icon(Icons.person, size: 50, color: primaryColor),
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
                    ),
                    child: Column(
                      children: [
                        _buildProfileOption(
                          context,
                          icon: Icons.email,
                          title: "Email",
                          onTap: () {},
                        ),
                        const Divider(height: 1, color: Color(0xFFD1BFA7)),
                        _buildProfileOption(
                          context,
                          icon: Icons.lock_outline,
                          title: "Change Password",
                          onTap: () {},
                        ),
                        const Divider(height: 1, color: Color(0xFFD1BFA7)),
                        _buildProfileOption(
                          context,
                          icon: Icons.privacy_tip_outlined,
                          title: "Privacy Policy",
                          onTap: () {},
                        ),
                        const Divider(height: 1, color: Color(0xFFD1BFA7)),
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
                        style: GoogleFonts.merriweather(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
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

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFFBF9D7E), size: 28),
      title: Text(
        title,
        style: GoogleFonts.merriweather(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2F2235),
        ),
      ),
      trailing:
          onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
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
    const primaryColor = Color(0xFF3A3042);
    const accentColor = Color(0xFFBF9D7E);
    const backgroundColor = Color(0xFFF9F5F0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Liked Recipes',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
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
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchLikedRecipes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: accentColor),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Failed to load recipes',
                        style: GoogleFonts.merriweather(),
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
                            color: accentColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No liked recipes yet',
                            style: GoogleFonts.merriweather(
                              fontSize: 16,
                              color: const Color(0xFF2F2235).withOpacity(0.6),
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
    const accentColor = Color(0xFFBF9D7E);
    const textColor = Color(0xFF2F2235);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to recipe detail
        },
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
                                color: accentColor.withOpacity(0.1),
                                child: Icon(
                                  Icons.restaurant,
                                  color: accentColor,
                                ),
                              ),
                        )
                        : Container(
                          width: 80,
                          height: 80,
                          color: accentColor.withOpacity(0.1),
                          child: Icon(Icons.restaurant, color: accentColor),
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
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe['category'],
                      style: GoogleFonts.merriweather(
                        fontSize: 14,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}
