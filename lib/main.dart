import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_application/screens/recipe/add_recipe_screen.dart';
import 'firebase_options.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/recipe/recipe_bloc.dart';
import 'bloc/recipe/recipe_event.dart';
import 'package:food_application/screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/recipe/recipe_list_screen.dart';
import 'screens/admin_screen.dart';
import 'bloc/auth/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(_firebaseAuth)),
        BlocProvider<RecipeBloc>(
          create: (_) => RecipeBloc()..add(LoadRecipes()),
        ),
      ],
      child: MaterialApp(
        title: 'Food Recipe App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepOrange,
        ),
        initialRoute: '/',
        routes: {
          '/':
              (context) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    if (state.isAdmin) {
                      return AdminPage();
                    } else {
                      return HomeScreen();
                    }
                  }
                  return LoginScreen();
                },
              ),
          '/login': (_) => LoginScreen(),
          '/signup': (_) => SignupScreen(),
          '/home': (_) => HomeScreen(),
          '/recipes': (_) => RecipeListScreen(),
          '/add-recipe': (_) => AddRecipeScreen(),
          '/admin': (_) => AdminPage(),
        },
        onGenerateRoute: (settings) {
          // Handle any undefined routes
          return MaterialPageRoute(
            builder:
                (context) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ),
          );
        },
      ),
    );
  }
}
