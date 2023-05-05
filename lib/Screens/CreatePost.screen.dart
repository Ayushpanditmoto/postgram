// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Providers/theme.provider.dart';
import '../Services/auth.services.dart';
import '../Services/firestore.services.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController confessionController = TextEditingController();
  FirebaseAuth auth = AuthMethod().auth;
  bool isLoading = false;
  Uint8List? _image;

  Map<String, dynamic> submitConfession = {
    'id': '0',
    'confession': "",
    'image': "",
  };

  _selectImages(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Image'),
      children: [
        SimpleDialogOption(
          child: const Text('Take a picture'),
          onPressed: () async {
            Navigator.pop(context);

            Uint8List? image = await pickImage(ImageSource.camera);

            if (image != null) {
              setState(() {
                _image = image;
              });
            }
          },
        ),
        SimpleDialogOption(
          child: const Text('Select from gallery'),
          onPressed: () async {
            Uint8List? image = await pickImage(ImageSource.gallery);

            if (image != null) {
              setState(() {
                _image = image;
              });
            } else {
              showSnackBar('No image selected', context);
            }
          },
        ),
        SimpleDialogOption(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  resetFields() {
    setState(() {
      confessionController.clear();
      _image = null;
    });
  }

  @override
  void dispose() {
    confessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Post',
              style: TextStyle(
                color: theme.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  if (confessionController.text.isEmpty) {
                    setState(() {
                      isLoading = false;
                    });
                    showSnackBar("Fill All the Information", context);
                    return;
                  }

                  String rev = await FirestoreMethods().uploadConfess(
                    uid: auth.currentUser!.uid,
                    content: confessionController.text,
                    image: _image ?? Uint8List(0),
                  );

                  if (rev == "success") {
                    resetFields();
                    setState(() {
                      isLoading = false;
                    });
                    showSnackBar("Posted", context);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    showSnackBar(rev, context);
                  }
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  showSnackBar(e.toString(), context);
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              isLoading
                  ? const LinearProgressIndicator(
                      backgroundColor: Colors.purple,
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    // borderRadius: BorderRadius.circular(0),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: confessionController,
                    minLines: 5,
                    maxLines: 40,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write your Post?',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 10,
              ),

              //drop down menu to choose between gender
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              //image picker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image == null
                      ? Center(
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => _selectImages(context));
                            },
                            child: const Text(
                              'Add Image (Optional)',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            Image.memory(
                              _image!,
                              fit: BoxFit.fitHeight,
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ));
  }
}
