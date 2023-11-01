// // A model class representing comment data.
// class CommentModel {
//   // Unique identifier for the comment.
//   final String id;

//   // User associated with the comment.
//   final String user;

//   // Unique identifier for the post associated with the comment.
//   final String post;

//   // Text content of the comment.
//   final String? text;

//   // Date and time when the comment was created.
//   final DateTime time;

//   // Constructor to initialize a CommentModel instance with required parameters.
//   CommentModel({
//     required this.id,
//     required this.user,
//     required this.post,
//     required this.text,
//     required this.time,
//   });

//   // Factory method to create a CommentModel instance from a JSON map.
//   factory CommentModel.fromJson(Map<String, dynamic> map) {
//     return CommentModel(
//       id: map['id'],
//       user: map['user'],
//       post: map['post'],
//       text: map['text'],
//       time: map['time'].toDate(), // Convert Firestore Timestamp to DateTime.
//     );
//   }

//   // Method to convert the CommentModel instance to a map for Firestore storage.
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'user': user,
//       'post': post,
//       'text': text,
//       'time': time,
//     };
//   }
// }
