// Import necessary packages for Firestore integration.
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_tutorials/social_app/models/post_model.dart';

// Import shared constants.
import 'package:flutter_tutorials/social_app/shared/constants.dart';

// A class containing static methods for handling post-related Firestore services.
class PostServices {
  // Create a new post in the Firestore 'posts' collection.
  static Future create({required PostModel postModel}) async {
    // Generate a new document reference
    DocumentReference documentReference = postsCollection.doc();

    // Set the post data in the document
    await documentReference.set(
      {
        'id': documentReference.id,
        'user': postModel.user,
        'text': postModel.text,
        'time': postModel.time,
        'photo': postModel.photo,
        'likes': postModel.likes,
      },
    );
  }

  // Delete a post from the Firestore 'posts' collection.
  static Future delete({required PostModel postModel}) async {
    // Delete the document with the specified post ID
    await postsCollection.doc(postModel.id).delete();
  }

  

  // Add a new comment to the Firestore 'comments' collection for a specific post.
  // static Future comment({required CommentModel commentModel}) async {
  //   // Generate a new document reference within the 'comments' subcollection of the specified post
  //   DocumentReference documentReference =
  //       commentsCollection(post: commentModel.post).doc();

  //   // Set the comment data in the document
  //   await documentReference.set(
  //     {
  //       'id': documentReference.id,
  //       'user': commentModel.user,
  //       'text': commentModel.text,
  //       'time': commentModel.time,
  //       'post': commentModel.post,
  //     },
  //   );
  // }

  // Retrieve a stream of all posts from the Firestore 'posts' collection.
  static Stream<List<PostModel>> readAll() {
    // Listen for snapshots of the entire 'posts' collection.
    return postsCollection
        // Order the posts by the 'time' field in descending order.
        .orderBy('time', descending: true)
        .snapshots()
        // Map the snapshots to a list of PostModel instances.
        .map((querySnapshot) {
      // Convert each document snapshot into a PostModel instance.
      return querySnapshot.docs.map((doc) {
        // Assuming you have a factory method in the PostModel class to create instances from the document data.
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // // Retrieve a stream of a specific post from the Firestore 'posts' collection based on post ID.
  // static Stream<DocumentSnapshot> read({required String post}) {
  //   // Return a stream of document snapshots for the specified post ID
  //   return postsCollection.doc(post).snapshots();
  // }

  // Retrieve a stream of posts from the Firestore 'posts' collection for a specific user.
  static Stream<List<PostModel>> readSpecificUser({required String user}) {
    // Use the 'where' clause to filter posts based on the 'user' field.
    return postsCollection
        .where('user', isEqualTo: user)
        // Order the posts by the 'time' field in descending order.
        .orderBy('time', descending: true)
        // Listen for snapshots of the query result.
        .snapshots()
        // Map the snapshots to a list of PostModel instances.
        .map((querySnapshot) {
      // Convert each document snapshot into a PostModel instance.
      return querySnapshot.docs.map((doc) {
        // Assuming you have a factory method in the PostModel class to create instances from the document data.
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Toggle like for a post.
  static Future likePost({required PostModel postModel}) async {
    // Get the current likes from the post
    List<dynamic> currentLikes = postModel.likes;

    // Check if the user already liked the post
    if (currentLikes.contains(currentUser!.uid)) {
      // If liked, remove the user from the likes list
      currentLikes.remove(currentUser!.uid);
    } else {
      // If not liked, add the user to the likes list
      currentLikes.add(currentUser!.uid);
    }

    // Update the post with the new likes list
    await postsCollection.doc(postModel.id).update({'likes': currentLikes});
  }

  // // Retrieve a stream of all comments for a specific post from the Firestore 'comments' subcollection.
  // Stream<QuerySnapshot> readComments({required String post}) {
  //   // Return a stream of document snapshots for the specified post ID within the 'comments' subcollection
  //   return commentsCollection(post: post).snapshots();
  // }
}
