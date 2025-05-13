import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';
import '../../models/recipe_model.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RecipeBloc() : super(RecipeInitial()) {
    // Handle LoadRecipes event
    on<LoadRecipes>((event, emit) async {
      emit(RecipeLoading());
      try {
        final snapshot = await _firestore.collection('recipes').get();
        final recipes =
            snapshot.docs
                .map((doc) => Recipe.fromMap(doc.data(), doc.id))
                .toList();
        emit(RecipeLoaded(recipes));
      } catch (e) {
        emit(RecipeError('Failed to load recipes: $e'));
      }
    });

    // Handle AddRecipe event
    on<AddRecipe>((event, emit) async {
      try {
        final docRef = await _firestore
            .collection('recipes')
            .add(event.recipe.toMap());
        final newRecipe = event.recipe.copyWith(id: docRef.id);

        if (state is RecipeLoaded) {
          final updatedList = List<Recipe>.from((state as RecipeLoaded).recipes)
            ..add(newRecipe);
          emit(RecipeLoaded(updatedList));
        } else {
          add(LoadRecipes());
        }
      } catch (e) {
        emit(RecipeError("Failed to add recipe: $e"));
      }
    });

    // Handle DeleteRecipe event
    on<DeleteRecipe>((event, emit) async {
      if (state is RecipeLoaded) {
        try {
          await _firestore.collection('recipes').doc(event.recipeId).delete();
          final updatedList = List<Recipe>.from((state as RecipeLoaded).recipes)
            ..removeWhere((recipe) => recipe.id == event.recipeId);
          emit(RecipeLoaded(updatedList));
        } catch (e) {
          emit(RecipeError("Failed to delete recipe: $e"));
        }
      }
    });
  }
}
