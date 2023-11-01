// Import necessary packages and local files.
import 'package:flutter/material.dart';
import 'package:flutter_tutorials/social_app/models/post_model.dart';
import 'package:flutter_tutorials/social_app/services/post_services.dart';
import 'package:flutter_tutorials/social_app/shared/constants.dart';
import 'package:flutter_tutorials/social_app/widgets/post_widget.dart';
import 'package:flutter_tutorials/social_app/widgets/user_widget.dart';

// Widget representing the user's profile page.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// State class for the ProfilePage widget.
class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        // Apply horizontal padding to the entire page.
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Sliver containing the user information card.
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                  child: UserWidget(user: currentUser!.uid),
                ),
              ),
            ),
            // Sliver with a list tile indicating "My Posts".
            const SliverToBoxAdapter(child: ListTile(title: Text("My Posts"))),
            // Sliver containing a stream of posts by the current user.
            StreamBuilder<List<PostModel>>(
              stream: PostServices.readSpecificUser(user: currentUser!.uid),
              builder: (context, snapshot) {
                // Check the connection state to determine the UI state.
                if (snapshot.connectionState == ConnectionState.active) {
                  // Extract the list of posts from the snapshot data.
                  List<PostModel> posts = snapshot.data ?? [];
                  if (posts.isNotEmpty) {
                    // Display a SliverList of PostWidgets if there are posts.
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return PostWidget(postModel: posts[index]);
                        },
                        childCount: posts.length,
                      ),
                    );
                  } else {
                    // Display a message if there are no posts.
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text("No Posts Yet"),
                      ),
                    );
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  // Display a loading indicator while waiting for data.
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  // Display an error message if there's an issue loading posts.
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text("Error Loading Posts"),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
