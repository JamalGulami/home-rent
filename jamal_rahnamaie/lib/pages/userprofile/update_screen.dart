import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jamal_rahnamaie/widgets/subtext.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen(
      {super.key,
      required this.title,
      required this.id,
      required this.desc,
      required this.phoneNumber});
  final String title;
  final String id;
  final String desc;
  final String phoneNumber;
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var number = TextEditingController();
  bool isUploading = false;

  @override
  void initState() {
    titleController.text = widget.title.toString();
    descriptionController.text = widget.title.toString();
    number.text = widget.phoneNumber.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        onPressed: () {
                          updateFieldByDocumentidAll(widget.id);
                        },
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

  updateFieldByDocumentidAll(String documentid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentReference documentReference =
          firestore.collection('rahnameiDatabase').doc(documentid);
      await documentReference.update({
        "title": titleController.text,
        "description": descriptionController.text,
        "phoneNumber": number.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('آگهی اپدید شد'),
          duration: Duration(seconds: 2),
        ),
      );

      print('Field  updated successfully.');
    } catch (error) {
      print('Error updating field: $error');
    }
  }
}
