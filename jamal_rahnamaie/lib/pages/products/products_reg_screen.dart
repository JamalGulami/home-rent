import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamal_rahnamaie/pages/catgories/catgories_screen.dart';
import 'package:jamal_rahnamaie/widgets/subtext.dart';

class ProductsRegistration extends StatefulWidget {
  const ProductsRegistration({super.key});

  @override
  State<ProductsRegistration> createState() => _ProductsRegistrationState();
}

class _ProductsRegistrationState extends State<ProductsRegistration> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final number = TextEditingController();

  File? _image;
  bool isUploading = false;
  String selectedCategory = ''; // Store the selected category
  String uploadMessage = '';

  void openCategoryScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const CategoryScreen(), // Pass your list of categories
      ),
    );

    if (result != null) {
      setState(() {
        selectedCategory = result;
      });
    }
  }

  Future<void> _uploadData() async {
    setState(() {
      isUploading = true; // Start the progress bar
    });
    final title = titleController.text;
    final description = descriptionController.text;
    final category = selectedCategory;

    if (title.isEmpty ||
        description.isEmpty ||
        category.isEmpty ||
        _image == null) {
      setState(() {
        isUploading = false; // Stop the progress bar
      });
      return;
    }

    try {
      // Upload image to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
      await storageRef.putFile(File(_image!.path));
      UploadTask uploadTask = storageRef.putFile(File(_image!.path));

      // Listen to the upload task's stream to update progress
      uploadTask.snapshotEvents.listen((event) {});
      // Get the download URL of the uploaded image
      final imageUrl = await storageRef.getDownloadURL();
      await uploadTask;

      // Add data to Firestore
      await FirebaseFirestore.instance.collection('rahnameiDatabase').add({
        'title': title,
        'description': description,
        'category': category,
        'image_url': imageUrl,
        'userid': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': Timestamp.now(),
        'status': false,
        'phoneNumber': number.text
      });
      setState(() {
        uploadMessage = 'آگهی موفقانه ثبت شد';
        isUploading = false; // Stop the progress bar
      });
      // Show a success message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('آگهی موفقانه ثبت شد'),
          duration: Duration(seconds: 2),
        ),
      );
      // Clear the input fields
      titleController.clear();
      descriptionController.clear();
      selectedCategory = "";

      setState(() {
        _image = null;
      });
    } catch (e) {
      setState(() {
        isUploading = false;
        uploadMessage = 'Error: $e';
        // Stop the progress bar in case of an error
      });
      debugPrint('Error: $e');
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      // No image selected, set a default image
      setState(() {
        // Replace 'default_image_path' with the path to your default image asset
        _image = Image.asset('assets/login.png') as File;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const ContentText(text: 'ثبت آگهی'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ContentText(
                text: 'یک عنوان برای آگهی خود وارید کنید',
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "عنوان",
                  fillColor: Colors.white70,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const ContentText(text: 'توضیحات آگهی خود را بنوسید'),
              TextField(
                maxLines: 6,
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "توضیحات آگهی",
                  fillColor: Colors.white70,
                ),
              ),
              const ContentText(text: 'انتخاب دسته بندی '),
              GestureDetector(
                onTap: () {
                  openCategoryScreen();
                },
                child: AbsorbPointer(
                  child: TextField(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: TextEditingController(text: selectedCategory),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: " دسته بندی",
                      fillColor: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _image == null
                  ? const ContentText(text: 'یک عکس برای آگهی خود انتخاب کنید')
                  : const ContentText(
                      text: 'عکس انتخاب شده است',
                      color: Colors.green,
                    ),
              _image == null
                  ? InkWell(
                      onTap: _getImage,
                      child: DottedBorder(
                        color: Colors.black,
                        strokeWidth: 1,
                        radius: const Radius.circular(10.0),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0), // Reduced padding
                          child: Icon(
                            Icons.add,
                            size: 40.0,
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: _getImage,
                      child: Image.file(
                        File(_image!.path),
                        height: 80.0,
                        width: 80.0,
                      ),
                    ),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: number,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "نمبر تلفن",
                  fillColor: Colors.white70,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _uploadData,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.blue,
                          foregroundColor:
                              Colors.white, // Change text color to white
                        ),
                        child: const Icon(Icons.upload),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
