// Import necessary packages for Firestore integration and Firebase authentication.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Retrieve the current authenticated user using Firebase authentication.
User? currentUser = FirebaseAuth.instance.currentUser;

// Reference to the Firestore collection containing user documents.
CollectionReference usersCollection =
    FirebaseFirestore.instance.collection("users");

// Reference to the Firestore collection containing post documents.
CollectionReference postsCollection =
    FirebaseFirestore.instance.collection("posts");

// // // Function that returns a reference to the Firestore collection containing comments for a specific post.
// CollectionReference commentsCollection({required String post}) =>
//     FirebaseFirestore.instance
//         .collection("posts")
//         .doc(post)
//         .collection("comments");
