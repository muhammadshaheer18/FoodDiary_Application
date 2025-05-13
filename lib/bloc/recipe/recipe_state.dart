import 'package:equatable/equatable.dart';
import '../../models/recipe_model.dart';

abstract class RecipeState extends Equatable {
  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  RecipeLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);

  @override
  List<Object> get props => [message];
}

// States for Add Recipe
class RecipeAdding extends RecipeState {}

class RecipeAdded extends RecipeState {}
