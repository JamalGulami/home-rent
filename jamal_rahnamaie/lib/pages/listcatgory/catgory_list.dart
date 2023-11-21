import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jamal_rahnamaie/pages/detailsproducts/details_products.dart';
import 'package:jamal_rahnamaie/utils/appconstent.dart';
import 'package:jamal_rahnamaie/widgets/subtext.dart';

class Listcatgory extends StatefulWidget {
  const Listcatgory({super.key});

  @override
  State<Listcatgory> createState() => _ListcatgoryState();
}

class _ListcatgoryState extends State<Listcatgory>
    with SingleTickerProviderStateMixin {
  Stream<List<Map<String, dynamic>>> getUserDataStream(String catgory) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection(
            'rahnameiDatabase') // Replace with your Firestore collection name
        .where('category', isEqualTo: catgory)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<Map<String, dynamic>> userDataList = [];
      for (var userDocument in querySnapshot.docs) {
        userDataList.add(userDocument.data() as Map<String, dynamic>);
      }
      return userDataList;
    });
  }

  final List<Tab> myTabs = [
    const Tab(text: 'خانه های فروشی'),
    const Tab(text: 'خانه های کرایی'),
    const Tab(text: 'خانه های گیروی'),
    const Tab(text: 'شبانه روزی'),
  ];

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length, // Match the number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const ContentText(text: 'لیست کتگوری'),
          bottom: TabBar(
            isScrollable: true,
            labelStyle: const TextStyle(fontFamily: 'ir'),
            indicatorSize: TabBarIndicatorSize.label,
            controller: tabController,
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: myTabs.map((Tab tab) {
            // Use the index of the tab to get the corresponding data stream
            //final index = myTabs.indexOf(tab);
            return StreamBuilder<List<Map<String, dynamic>>>(
              stream: getUserDataStream(tab.text.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Show a loading indicator while data is being fetched.
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: ContentText(text: 'آگهی ثبت نشده است'),
                    ); // Handle the case where no data is found.
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var userData = snapshot.data![index];
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
                                                imageUrl: userData['image_url'],
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
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
                                            text:
                                                userData['title'] ?? 'No Title',
                                            size: 18.0,
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
            );
          }).toList(),
        ),
      ),
    );
  }
}
