// A model class representing post data.
class PostModel {
  // Unique identifier for the post.
  final String? id;

  // User associated with the post.
  final String user;

  // Text content of the post.
  final String? text;

  // URL of an optional photo attached to the post.
  final String? photo;

  // Date and time when the post was created.
  final DateTime time;

  // List of user IDs who liked the post.
  final List<dynamic> likes;

  // Constructor to initialize a PostModel instance with required parameters.
  PostModel({
    required this.id,
    required this.user,
    required this.text,
    required this.time,
    required this.photo,
    required this.likes,
  });

  // Factory method to create a PostModel instance from a JSON map.
  factory PostModel.fromJson(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      user: map['user'],
      text: map['text'],
      time: map['time'].toDate(), // Convert Firestore Timestamp to DateTime.
      photo: map['photo'],
      likes: map['likes'],
    );
  }
}
