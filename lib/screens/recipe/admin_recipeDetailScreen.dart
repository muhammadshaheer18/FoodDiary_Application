// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/recipe_model.dart';
import '../../models/comment_model.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AdminRecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const AdminRecipeDetailScreen({super.key, required this.recipe});

  @override
  State<AdminRecipeDetailScreen> createState() =>
      _AdminRecipeDetailScreenState();
}

class _AdminRecipeDetailScreenState extends State<AdminRecipeDetailScreen> {
  // Sophisticated color scheme
  static const Color primaryColor = Color(0xFF3A3042);
  static const Color accentColor = Color(0xFFBF9D7E);
  static const Color backgroundColor = Color(0xFFF9F5F0);
  static const Color textColor = Color(0xFF2F2235);
  static const Color dividerColor = Color(0xFFD1BFA7);

  // Animation controllers for elegant transitions
  late ScrollController _scrollController;
  double _titleOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController =
        ScrollController()..addListener(() {
          setState(() {
            _titleOpacity = (_scrollController.offset / 200).clamp(0.0, 1.0);
          });
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Get comments stream
  Stream<List<Comment>> _getComments() {
    return FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipe.id)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Comment.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  // Delete a comment
  Future<void> _deleteComment(String commentId) async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipe.id)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  // Format timestamp elegantly
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown date';

    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is DateTime) {
      dateTime = timestamp;
    } else {
      return 'Invalid date';
    }

    return DateFormat('MMMM d, y • h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom SliverAppBar with parallax effect and elegant overlay
          SliverAppBar(
            expandedHeight: size.height * 0.5,
            pinned: true,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedOpacity(
                opacity: _titleOpacity,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  recipe.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image with parallax effect
                  Hero(
                    tag: 'recipe-${recipe.id}',
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: accentColor.withOpacity(0.3),
                            child: Icon(
                              Icons.restaurant,
                              size: 64,
                              color: primaryColor,
                            ),
                          ),
                    ),
                  ),
                  // Elegant gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          primaryColor.withOpacity(0.7),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                  // Recipe title positioned at bottom
                  Positioned(
                    bottom: 48,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 8.0,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: primaryColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // Recipe Details Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe metadata section
                  Row(
                    children: [
                      _buildInfoItem(
                        Icons.access_time,
                        '${recipe.cookTime} min',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Recipe description with elegant typography
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: dividerColor, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About This Recipe',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          recipe.description,
                          style: GoogleFonts.carroisGothic(
                            fontSize: 15,
                            height: 1.7,
                            color: textColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Classic ornamental divider
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Divider(color: dividerColor, thickness: 1),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            color: backgroundColor,
                            child: Icon(
                              Icons.local_dining,
                              color: accentColor,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Comments management section with elegant card design
                  Text(
                    "Comments Management",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Comments list with elegant styling
          StreamBuilder<List<Comment>>(
            stream: _getComments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: accentColor),
                  ),
                );
              }

              final comments = snapshot.data ?? [];

              if (comments.isEmpty) {
                return SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: accentColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No comments yet",
                          style: GoogleFonts.carroisGothic(
                            fontSize: 16,
                            color: textColor.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final comment = comments[index];
                    return _buildCommentCard(context, comment);
                  }, childCount: comments.length),
                ),
              );
            },
          ),

          // Footer space
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // Elegant comment card with sophisticated design
  Widget _buildCommentCard(BuildContext context, Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: dividerColor.withOpacity(0.5), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {}, // For ripple effect
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User avatar (using first letter of email)
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: accentColor,
                        child: Text(
                          comment.userEmail.isNotEmpty
                              ? comment.userEmail[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Comment content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.userEmail,
                              style: GoogleFonts.carroisGothic(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTimestamp(comment.timestamp),
                              style: GoogleFonts.carroisGothic(
                                fontSize: 12,
                                color: textColor.withOpacity(0.6),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              comment.text,
                              style: GoogleFonts.carroisGothic(
                                fontSize: 14,
                                height: 1.5,
                                color: textColor.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Delete button with elegant styling
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: dividerColor),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          onPressed:
                              () =>
                                  _showDeleteCommentDialog(context, comment.id),
                          tooltip: 'Delete Comment',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Elegant metadata item
  Widget _buildInfoItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accentColor, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.carroisGothic(
              fontSize: 14,
              color: textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Refined delete dialog with sophisticated design
  void _showDeleteCommentDialog(BuildContext context, String commentId) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            backgroundColor: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber,
                    size: 48,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Delete Comment",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Are you sure you want to delete this comment? This action cannot be undone.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.carroisGothic(
                      fontSize: 14,
                      height: 1.5,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cancel button
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          side: BorderSide(color: accentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.carroisGothic(
                            color: accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Delete button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _deleteComment(commentId);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Comment deleted",
                                style: GoogleFonts.carroisGothic(),
                              ),
                              backgroundColor: primaryColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Delete",
                          style: GoogleFonts.carroisGothic(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
