// Import necessary packages and local pages.
import 'package:flutter/material.dart';
import 'package:flutter_tutorials/social_app/pages/create_post_page.dart';
import 'package:flutter_tutorials/social_app/pages/posts_page.dart';
import 'package:flutter_tutorials/social_app/pages/profile_page.dart';
import 'package:get/get.dart';

// A stateful widget representing the main home page.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// The state class for the HomePage widget.
class _HomePageState extends State<HomePage> {
  // Index representing the currently selected page.
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar at the top of the page.
      appBar: AppBar(
        title: const Text("We Social"),
      ),
      // Floating action button to navigate to the CreatePostPage.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const CreatePostPage());
        },
        child: const Icon(Icons.create),
      ),
      // Body content based on the selected page.
      body: [const PostsPage(), const ProfilePage()][page],
      // Bottom navigation bar for switching between Posts and Profile pages.
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        // Callback for handling the selected destination.
        onDestinationSelected: (value) {
          setState(() {
            page = value;
          });
        },
        // List of navigation destinations.
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: "Posts",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
