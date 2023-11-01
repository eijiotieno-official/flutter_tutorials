import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorials/social_app/models/user_model.dart';
import 'package:flutter_tutorials/social_app/services/user_services.dart';

/// A widget representing user information.
class UserWidget extends StatelessWidget {
  /// The user ID for whom the information is displayed.
  final String user;

  /// Constructs a [UserWidget] with the specified [user].
  const UserWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: UserServices.read(id: user),
      builder: (context, snapshot) {
        // Check if user data has been loaded.
        if (snapshot.hasData) {
          UserModel userModel = snapshot.data!;
          // Display user information in a ListTile.
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                userModel.photo,
              ),
            ),
            title: Text(userModel.name),
            subtitle: Text(userModel.email),
          );
        }
        // Return an empty SizedBox if user data is not yet available.
        return const SizedBox.shrink();
      },
    );
  }
}
