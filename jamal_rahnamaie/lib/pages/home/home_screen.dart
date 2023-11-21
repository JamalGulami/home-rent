import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamal_rahnamaie/pages/detailsproducts/details_products.dart';
import 'package:jamal_rahnamaie/pages/userlogin/login_page.dart';
import 'package:jamal_rahnamaie/pages/userlogin/login_sign_up.dart';
import 'package:jamal_rahnamaie/utils/appconstent.dart';
import 'package:jamal_rahnamaie/widgets/app_drawer.dart';
import 'package:jamal_rahnamaie/widgets/subtext.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  HomescreenState createState() => HomescreenState();
}

class HomescreenState extends State<Homescreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final searchController = TextEditingController();
  Stream<QuerySnapshot>? searchStream;
  bool showNewItems = false;
  User? user = FirebaseAuth.instance.currentUser;
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      _searchData(searchController.text);
    });
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const ContentText(text: 'توجه!'),
          content:
              const ContentText(text: 'آیا می خواهید از برنامه خارج شوید؟'),
          actions: <Widget>[
            TextButton(
              child: const ContentText(text: 'نخیر'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const ContentText(text: 'بلی'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoaginSignUp()));
              },
            ),
          ],
        );
      },
    );
  }

  void _searchData(String searchText) {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    setState(() {
      if (showNewItems) {
        searchStream = _firestore
            .collection('rahnameiDatabase')
            .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
            .where('status', isEqualTo: false)
            .snapshots();
      } else if (searchText.isEmpty) {
        searchStream = _firestore
            .collection('rahnameiDatabase')
            .where('status', isEqualTo: false)
            .snapshots();
      } else {
        searchStream = _firestore
            .collection('rahnameiDatabase')
            .where('title', isGreaterThanOrEqualTo: searchText)
            .where('status', isEqualTo: false)
            .snapshots();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const ContentText(text: 'مسکن یاب'),
          backgroundColor: Colors.amber,
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.login),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 'logout') {
                  showLogoutDialog(context);
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            TextField(
              controller: searchController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: GestureDetector(
                    onTap: () {}, child: const Icon(Icons.search)),
                hintText: 'جستجوی خانه',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'ir',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            //asdf

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: searchStream ??
                    _firestore
                        .collection('rahnameiDatabase')
                        .where('status', isEqualTo: false)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final documents = snapshot.data!.docs;
                  if (documents.isEmpty) {}
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final data =
                            documents[index].data() as Map<String, dynamic>;
                        final imageURL = data['image_url'] as String;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsDetails(
                                  title: data['title'],
                                  description: data['description'],
                                  category: data['category'],
                                  imageUrl: data['image_url'],
                                  numberPhone: data['phoneNumber'],
                                  productId: documents[index].id.toString(),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: const Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 140,
                                        height: 140.0,
                                        child: imageURL.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                    10), // Adjust the radius as needed
                                                child: CachedNetworkImage(
                                                  imageUrl: imageURL,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              )
                                            : const Placeholder(), // Display a placeholder if no image URL
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ContentText(
                                              text: data['title'] ?? 'No Title',
                                              size: 18.0,
                                            ),
                                            SingleChildScrollView(
                                              child: Text(
                                                data['description'] ??
                                                    'No Description',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontFamily: 'ir',
                                                    fontSize: 16.0,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            //const Spacer(),
                                            Row(
                                              children: [
                                                const Icon(Icons.timer),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: ContentText(
                                                      size: 12.0,
                                                      color: Colors.black54,
                                                      text: LikeDislikeCounter
                                                          .timeAgoFromTimestamp(
                                                              data[
                                                                  'timestamp'])),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
