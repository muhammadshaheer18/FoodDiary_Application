import 'package:equatable/equatable.dart';
import 'package:food_application/models/recipe_model.dart';

abstract class RecipeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {}

class AddRecipe extends RecipeEvent {
  final Recipe recipe;
  AddRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class DeleteRecipe extends RecipeEvent {
  final String recipeId;
  DeleteRecipe(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}
