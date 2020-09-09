import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutix/models/models.dart';
import 'package:flutix/extensions/extensions.dart';
import 'package:flutix/services/user_service.dart';

class AuthServices {
  static auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  static Future<SignInSignUpResult> signUp(String email, String password, String name, List<String> selectedGenres, String selectedLanguage, {profilePhoto: ''}) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password
      );
      User user = result.user.convertToUser(
        name: name,
        profilePicture: profilePhoto,
        selectedGenres: selectedGenres,
        selectedLanguage: selectedLanguage
      );

      await UserService.updateUser(user);

      return SignInSignUpResult(user: user);
    } catch (e) {
      String error = 'Failed to register';
      switch(e.code) {
        case 'email-already-in-use':
          error = 'Email address already registered';
          break;
        case 'weak-password':
          error = 'Weak password, pick another password';
          break;
        case 'invalid-email':
          error = 'Invalid email address';
          break;
      }
      return SignInSignUpResult(message: error);
    }
  }

  static Future<SignInSignUpResult> signIn(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password
      );

      User user = await result.user.fromFireStore();

      return SignInSignUpResult(user: user);
    } catch (e) {
      String error = 'Failed to sign in';
      switch(e.code) {
        case 'user-not-found':
          error = 'Your email is not registered on our system';
          break;
        case 'wrong-password':
          error = 'Wrong email or password, try again';
          break;
        case 'too-many-requests':
          error = 'You attempt login to many, please wait a moment';
          break;
      }
      return SignInSignUpResult(message: error);
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<bool> isUserLoggedIn() async {
    var user = _auth.currentUser;
    return user != null;
  }
}

class SignInSignUpResult {
  final User user;
  final String message;

  SignInSignUpResult({this.user, this.message});
}
