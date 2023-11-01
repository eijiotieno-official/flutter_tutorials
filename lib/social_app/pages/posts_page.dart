// Import necessary packages and local files.
import 'package:flutter/material.dart';
import 'package:flutter_tutorials/social_app/models/post_model.dart';
import 'package:flutter_tutorials/social_app/services/post_services.dart';
import 'package:flutter_tutorials/social_app/widgets/post_widget.dart';

// Widget representing the page displaying posts.
class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

// State class for the PostsPage widget.
class _PostsPageState extends State<PostsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Apply horizontal padding to the entire page.
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: StreamBuilder<List<PostModel>>(
        // StreamBuilder to reactively display posts when the stream updates.
        stream: PostServices.readAll(),
        builder: (context, snapshot) {
          // Check the connection state to determine the UI state.
          if (snapshot.connectionState == ConnectionState.active) {
            // Extract the list of posts from the snapshot data.
            List<PostModel> posts = snapshot.data ?? [];
            if (posts.isNotEmpty) {
              // Display a ListView of PostWidgets if there are posts.
              return ListView.builder(
                itemCount: posts.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return PostWidget(postModel: posts[index]);
                },
              );
            } else {
              // Display a message if there are no posts.
              return const Center(
                child: Text("No Posts Yet"),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for data.
            return const Center(child: CircularProgressIndicator());
          } else {
            // Display an error message if there's an issue loading posts.
            return const Center(child: Text("Error Loading Posts"));
          }
        },
      ),
    );
  }
}
