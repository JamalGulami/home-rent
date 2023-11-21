import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamal_rahnamaie/pages/detailsproducts/details_products.dart';
import 'package:jamal_rahnamaie/pages/userprofile/update_screen.dart';
import 'package:jamal_rahnamaie/utils/appconstent.dart';
import 'package:jamal_rahnamaie/widgets/subtext.dart';
import 'package:popup_menu/popup_menu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Stream<List<Map<String, dynamic>>> getUserDataStream(String userId) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection('rahnameiDatabase')
        .where('userid', isEqualTo: userId)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<Map<String, dynamic>> userDataList = [];
      for (var userDocument in querySnapshot.docs) {
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;
        userData['documentId'] =
            userDocument.id; // Add the document ID to userData
        userDataList.add(userData);
      }
      return userDataList;
    });
  }

  void showPopupMenu(BuildContext context, String documentId, GlobalKey key) {
    final RenderBox? itemBox =
        key.currentContext?.findRenderObject() as RenderBox?;

    if (itemBox != null) {
      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      final Offset position =
          itemBox.localToGlobal(Offset.zero, ancestor: overlay);

      final popupMenu = PopupMenu(
        items: [
          MenuItem(
            title: 'Delete',
          ),
        ],
        context: context,
        onClickMenu: (item) {
          deleteData(context, documentId);
        },
        onDismiss: () {},
      );

      popupMenu.show(rect: Rect.fromPoints(position, position));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const ContentText(text: 'پروفایل'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40.0,
            ),
            Center(
              child: Image.asset(
                'assets/login.png',
                width: 80.0,
                height: 80.0,
              ),
            ),
            ContentText(
              text: user?.displayName ?? '',
              size: 20.0,
            ),
            ContentText(
              text: user?.email ?? '',
              size: 16.0,
              color: Colors.black87,
            ),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: getUserDataStream(auth.currentUser!.uid.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Show a loading indicator while data is being fetched.
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.data!.isEmpty) {
                      return const Text(
                          'دیتا یافت نشد'); // Handle the case where no data is found.
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var userData = snapshot.data![index];
                        String documentId = userData['documentId'];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsDetails(
                                  title: userData['title'],
                                  description: userData['description'],
                                  category: userData['category'],
                                  imageUrl: userData['image_url'],
                                  numberPhone: userData['phoneNumber'],
                                  productId:
                                      snapshot.data![index].keys.toString(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 140,
                                        height: 140.0,
                                        child: userData['image_url'].isNotEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                    10), // Adjust the radius as needed
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      userData['image_url'],
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    userData['title'] ??
                                                        'No Title',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontFamily: 'ir'),
                                                  ),
                                                ),
                                                PopupMenuButton<int>(
                                                  onSelected: (value) {
                                                    if (value == 1) {
                                                      // Delete action
                                                      deleteData(
                                                          context, documentId);
                                                    } else if (value == 2) {
                                                      updateFieldByDocumentid(
                                                          documentId,
                                                          "status",
                                                          userData['status']
                                                              .toString());
                                                    } else if (value == 3) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => UpdateScreen(
                                                                  phoneNumber: userData[
                                                                          'phoneNumber']
                                                                      .toString(),
                                                                  title: userData[
                                                                          'title']
                                                                      .toString(),
                                                                  id:
                                                                      documentId,
                                                                  desc: userData[
                                                                      'description'])));
                                                    }
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context) =>
                                                          <PopupMenuEntry<int>>[
                                                    const PopupMenuItem<int>(
                                                      value: 1,
                                                      child: Text('حذف'),
                                                    ),
                                                    // Add your condition here
                                                    PopupMenuItem<int>(
                                                      value: 2,
                                                      child: ContentText(
                                                          text: userData[
                                                                      'status']
                                                                  .toString()
                                                                  .contains(
                                                                      'false')
                                                              ? 'هایت'
                                                              : 'نشان'),
                                                    ),
                                                    const PopupMenuItem<int>(
                                                      value: 3,
                                                      child: ContentText(
                                                          text: 'اپدید'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            Text(
                                              userData['description'] ??
                                                  'No Description',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontFamily: 'ir',
                                                  fontSize: 16.0,
                                                  color: Colors.black54),
                                            ),
                                            //const Spacer(),
                                            Row(
                                              children: [
                                                const Icon(Icons.timeline),
                                                ContentText(
                                                    size: 12.0,
                                                    color: Colors.black54,
                                                    text: LikeDislikeCounter
                                                        .timeAgoFromTimestamp(
                                                            userData[
                                                                'timestamp'])),
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
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }

  deleteData(BuildContext context, String documentId) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference the Firestore collection and document to be deleted
      CollectionReference collection = firestore.collection('rahnameiDatabase');
      DocumentReference documentReference = collection.doc(documentId);

      // Delete the document
      documentReference.delete().then((value) {
        // Document successfully deleted
        print('Document successfully deleted.');
      }).catchError((error) {
        // Handle the error if the document couldn't be deleted
        print('Error deleting document: $error');
      });
    } catch (error) {
      // Handle any other error that might occur
      print('Error: $error');
    }
  }

  void updateFieldByDocumentid(
      String documentid, String status, String check) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Replace 'your_collection_name' with the name of your Firestore collection
      // Replace 'your_user_id_field' with the field that contains the user ID
      // Replace 'your_user_id' with the specific user ID you want to update
      DocumentReference documentReference =
          firestore.collection('rahnameiDatabase').doc(documentid);
      if (check.contains('true')) {
        await documentReference.update({
          status: false,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('آگهی پخش شد'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        await documentReference.update({
          status: true,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('آگهی پنهان شد'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      print('Field $status updated successfully.');
    } catch (error) {
      print('Error updating field: $error');
    }
  }
}
