import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorials/social_app/models/post_model.dart';
import 'package:flutter_tutorials/social_app/models/user_model.dart';
import 'package:flutter_tutorials/social_app/services/post_services.dart';
import 'package:flutter_tutorials/social_app/services/user_services.dart';
import 'package:flutter_tutorials/social_app/shared/constants.dart';
import 'package:flutter_tutorials/social_app/shared/utils.dart';
import 'package:flutter_tutorials/social_app/widgets/photo_widget.dart';

/// A widget representing a post in the social app.
class PostWidget extends StatelessWidget {
  /// The data model for the post.
  final PostModel postModel;

  /// Constructs a [PostWidget] with the specified [postModel].
  const PostWidget({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: UserServices.read(id: postModel.user),
      builder: (context, snapshot) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          // Opacity is set to 0.0 if user data is not loaded yet, making the widget invisible during loading.
          opacity: snapshot.data == null ? 0.0 : 1.0,
          child: Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              minVerticalPadding: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (snapshot.data != null) userWidget(snapshot.data!),
                  if (postModel.text != null) Text(postModel.text!),
                  if (postModel.photo != null)
                    PhotoWidget(url: postModel.photo!),
                  likeButtonWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Returns a widget displaying user information.
  Widget userWidget(UserModel userModel) => ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            userModel.photo,
          ),
        ),
        title: Text(userModel.name),
        subtitle: Text(formatTimeFromNow(dateTime: postModel.time)),
        trailing: postModel.user == currentUser!.uid
            ? IconButton.filledTonal(
                onPressed: () {
                  // Delete the post if the user is the author.
                  PostServices.delete(postModel: postModel);
                },
                icon: const Icon(Icons.delete),
              )
            : null,
      );

  /// Returns a widget representing the like button and the number of likes.
  Widget likeButtonWidget() => TextButton.icon(
        onPressed: () {
          // Handle liking/unliking the post.
          PostServices.likePost(postModel: postModel);
        },
        icon: Icon(
          // Display thumbs-up or outlined thumbs-up based on user's like status.
          postModel.likes.contains(currentUser!.uid)
              ? Icons.thumb_up
              : Icons.thumb_up_outlined,
        ),
        label: Text(postModel.likes.length.toString()),
      );
}
