// Import necessary packages.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tutorials/social_app/models/post_model.dart';
import 'package:flutter_tutorials/social_app/services/post_services.dart';
import 'package:flutter_tutorials/social_app/shared/constants.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

// A stateful widget for creating a new post.
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

// The state class for the CreatePostPage widget.
class _CreatePostPageState extends State<CreatePostPage> {
  TextEditingController textEditingController = TextEditingController();
  File? photo;
  double uploadProgress = 0.0;
  bool uploading = false;

  // Upload the selected photo to Firebase Storage.
  Future<void> uploadPhoto() async {
    String fileName = path.basename(photo!.path);
    Reference storageReference = FirebaseStorage.instance.ref();
    Reference fileReference = storageReference.child("files/$fileName");
    UploadTask uploadTask = fileReference.putFile(photo!);

    uploadTask.snapshotEvents.listen(
      (TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            setState(() {
              uploading = true;
              uploadProgress =
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            });
            break;
          case TaskState.success:
            String url = await taskSnapshot.ref.getDownloadURL();
            await PostServices.create(
              postModel: PostModel(
                id: null,
                user: currentUser!.uid,
                text: textEditingController.text.trim(),
                time: DateTime.now(),
                photo: url,
                likes: [],
              ),
            ).then((_) => Get.back());
            break;
          case TaskState.error:
            setState(() {
              uploading = false;
              uploadProgress = 0.0;
            });
            break;
          default:
        }
      },
    );
  }

  // Build the text field for entering post text.
  Widget buildTextField() {
    return TextField(
      autofocus: true,
      enabled: !uploading,
      controller: textEditingController,
      maxLines: null,
      onChanged: (value) {
        setState(() {});
      },
      decoration: const InputDecoration(
        hintText: "What's on your mind?",
      ),
    );
  }

  // Build the widget to display the selected photo.
  Widget buildSelectedPhoto() {
    return photo != null
        ? Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image.file(photo!),
          )
        : const SizedBox.shrink();
  }

  // Build the progress indicator for photo upload.
  Widget buildUploadProgressIndicator() {
    return AnimatedOpacity(
      opacity: uploading ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: CircularProgressIndicator(value: uploadProgress),
      ),
    );
  }

  // Build buttons for selecting or removing a photo.
  Widget buildPhotoButtons() {
    return AnimatedOpacity(
      opacity: uploading ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                ImagePicker().pickImage(source: ImageSource.gallery).then(
                  (value) {
                    if (value != null) {
                      setState(() {
                        photo = File(value.path);
                      });
                    }
                  },
                );
              },
              child: Text(photo == null ? "Pick a photo" : "Change photo"),
            ),
            const SizedBox(width: 20),
            if (photo != null)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    photo = null;
                  });
                },
                child: const Text("Remove photo"),
              ),
          ],
        ),
      ),
    );
  }

  // Build the floating action button for posting.
  Widget buildFloatingActionButton() {
    return AnimatedOpacity(
      opacity: !uploading && textEditingController.text.trim().isNotEmpty
          ? 1.0
          : 0.0,
      duration: const Duration(milliseconds: 500),
      child: FloatingActionButton(
        onPressed: () async {
          if (photo != null) {
            uploadPhoto();
          } else {
            await PostServices.create(
              postModel: PostModel(
                id: null,
                user: currentUser!.uid,
                text: textEditingController.text.trim(),
                time: DateTime.now(),
                photo: null,
                likes: [],
              ),
            ).then((_) => Get.back());
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New post")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              buildTextField(),
              buildSelectedPhoto(),
              buildUploadProgressIndicator(),
              buildPhotoButtons(),
            ],
          ),
        ),
      ),
      floatingActionButton: buildFloatingActionButton(),
    );
  }
}
