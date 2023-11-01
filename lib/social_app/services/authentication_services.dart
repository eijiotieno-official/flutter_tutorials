// Import necessary packages for Firebase authentication, user models, user services, and Google Sign-In.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tutorials/social_app/models/user_model.dart';
import 'package:flutter_tutorials/social_app/services/user_services.dart';
import 'package:flutter_tutorials/social_app/shared/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

// A class containing static methods for handling authentication services.
class AuthenticationServices {
  // Initiates the Google Sign-In process and returns a UserCredential upon successful authentication.
  static Future<UserCredential> signInWithGoogle() async {
    // Initiate Google Sign-In
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    // Convert Google authentication into Firebase credentials
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    // Sign in with Firebase and return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Performs user login using Google authentication and updates user data if necessary.
  static Future logIn() async {
    // Sign in with Google
    UserCredential userCredential = await signInWithGoogle();

    // Read user data from services
    UserModel? userModel =
        await UserServices.read(id: userCredential.user!.uid);

    // If user data does not exist, create a new user document
    if (userModel == null) {
      await usersCollection.doc(userCredential.user!.uid).set(
        {
          'id': userCredential.user!.uid,
          'name': userCredential.user!.displayName,
          'photo': userCredential.user!.photoURL,
          'email': userCredential.user!.email,
        },
      );
    }
  }

  // Signs out the user by revoking Google sign-in and Firebase authentication.
  static Future logOut() async {
    // Revoke Google Sign-In
    await GoogleSignIn().signOut();

    // Revoke Firebase authentication
    await FirebaseAuth.instance.signOut();
  }
}
