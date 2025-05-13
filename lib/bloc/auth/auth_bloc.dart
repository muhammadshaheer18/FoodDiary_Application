import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc(this._auth) : super(AuthInitial()) {
    on<AuthSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': event.email,
          'createdAt': DateTime.now(),
        });

        emit(AuthAuthenticated(isAdmin: false));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        // Check for admin credentials
        if (event.email == 'shaheer@gmail.com' && event.password == 'shaheer') {
          emit(AuthAuthenticated(isAdmin: true));
        } else {
          emit(AuthAuthenticated(isAdmin: false));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      await _auth.signOut();
      emit(AuthLoggedOut());
    });
  }
}
