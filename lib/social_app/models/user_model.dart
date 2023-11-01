// A model class representing user data.
class UserModel {
  // Unique identifier for the user.
  final String id;

  // User's name.
  final String name;

  // User's email address.
  final String email;

  // User's profile photo URL.
  final String photo;

  // Constructor to initialize a UserModel instance with required parameters.
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
  });

  // Factory method to create a UserModel instance from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      photo: map['photo'],
    );
  }
}
