// Import necessary packages for Firestore integration, user models, and shared constants.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tutorials/social_app/models/user_model.dart';
import 'package:flutter_tutorials/social_app/shared/constants.dart';

// A class containing static methods for handling user-related services.
class UserServices {
  // Fetches user data from Firestore based on the provided user ID.
  static Future<UserModel?> read({required String id}) async {
    // Initialize a variable to hold the retrieved user model
    UserModel? userModel;

    // Retrieve the Firestore document snapshot for the specified user ID
    DocumentSnapshot? documentSnapshot = await usersCollection.doc(id).get();

    // Convert the Firestore data into a UserModel using the model's fromJson method
    userModel = documentSnapshot.exists
        ? UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>)
        : null;

    // Return the retrieved user model
    return userModel;
  }
}
