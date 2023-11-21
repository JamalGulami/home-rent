import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamal_rahnamaie/models/fav_model.dart';
import 'package:jamal_rahnamaie/pages/detailsproducts/comment_screen.dart';
import 'package:jamal_rahnamaie/utils/appconstent.dart';
import 'package:jamal_rahnamaie/widgets/boxes.dart';
import 'package:jamal_rahnamaie/widgets/subtext.dart';

class ProductsDetails extends StatefulWidget {
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final String numberPhone;
  final String productId; // Add productId as a parameter

  const ProductsDetails({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.productId,
    required this.numberPhone,
  });

  @override
  State<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  bool isLiked = false;
  bool isDisliked = false;
  bool isLiked1 = false;

  bool isFavAdded = false;
  var likeDislikeCounter = LikeDislikeCounter();

  int commentCount = 0;
  User? user = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getDislikeCount(String productId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('likes')
        .where('productId', isEqualTo: productId)
        .where('type', isEqualTo: 'dislike')
        .get();

    return querySnapshot.docs.length;
  }

  bool searchInHiveBox(String searchText) {
    final box = Boxes.getHistory();
    List<String> matchingProductIds = [];

    for (var result in box.values) {
      if (result.productId.contains(searchText)) {
        matchingProductIds.add(result.productId);
      }
    }

    if (matchingProductIds.isNotEmpty) {
      return true; // Join the matching product IDs with a comma or any separator
    } else {
      return false;
    }
  }

  void checkIfLikedOrDisliked() async {
    // Query Firestore to check if the user has liked the post
    final likeDoc = await FirebaseFirestore.instance
        .collection('likes')
        .doc(widget.productId)
        .collection('users')
        .doc(user!.uid)
        .get();

    // Query Firestore to check if the user has disliked the post
    final dislikeDoc = await FirebaseFirestore.instance
        .collection('dislikes')
        .doc(widget.productId)
        .collection('users')
        .doc(user!.uid)
        .get();

    setState(() {
      isLiked = likeDoc.exists;
      isDisliked = dislikeDoc.exists;
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      isDisliked = false; // Reset dislike status when liking
    });

    // Update Firestore based on the like status
    if (isLiked) {
      // User liked the post
      FirebaseFirestore.instance
          .collection('likes')
          .doc(widget.productId)
          .collection('users')
          .doc(user!.uid)
          .set({});
    } else {
      // User unliked the post
      FirebaseFirestore.instance
          .collection('likes')
          .doc(widget.productId)
          .collection('users')
          .doc(user!.uid)
          .delete();
    }
  }

  void toggleDislike() {
    setState(() {
      isDisliked = !isDisliked;
      isLiked = false; // Reset like status when disliking
    });

    // Update Firestore based on the dislike status
    if (isDisliked) {
      // User disliked the post
      FirebaseFirestore.instance
          .collection('dislikes')
          .doc(widget.productId)
          .collection('users')
          .doc(user!.uid)
          .set({});
    } else {
      // User undisliked the post
      FirebaseFirestore.instance
          .collection('dislikes')
          .doc(widget.productId)
          .collection('users')
          .doc(user!.uid)
          .delete();
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfLikedOrDisliked();

    fetchCommentCount();
  }

  Future<void> fetchCommentCount() async {
    try {
      final QuerySnapshot commentSnapshot = await FirebaseFirestore.instance
          .collection('comments')
          .where('productId', isEqualTo: widget.productId)
          .get();

      // Set the comment count based on the number of comments retrieved
      setState(() {
        commentCount = commentSnapshot.docs.length;
      });
    } catch (error) {
      print('Error fetching comment count: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String productId =
        widget.productId; // Replace with the actual product ID
    return Scaffold(
      appBar: AppBar(
        title: const ContentText(text: 'جزییات آگهی'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.imageUrl.isNotEmpty
                  ? SizedBox(
                      width: double.infinity,
                      height: 280.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius as needed
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child:
                                  Center(child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    )
                  : const Placeholder(), // Display the image
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ContentText(
                    text: widget.title,
                    size: 24,
                  ),
                  //fav
                  IconButton(
                      onPressed: () async {
                        if (searchInHiveBox(widget.productId)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('قبلا اضافه شده')),
                          );
                        } else {
                          final box = Boxes.getHistory();
                          final product = FavModel(
                            productId: widget.productId,
                            title: widget.title,
                            description: widget.description,
                            category: widget.category,
                            imageUrl: widget.imageUrl,
                          );
                          box.add(product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('به اعلاقه مندی ها اضافه شد')),
                          );
                        }

                        // add to favorite
                      },
                      icon: searchInHiveBox(widget.productId)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite)),
                ],
              ),
              Row(
                children: [
                  const ContentText(
                    text: ' دسته بندی :',
                    size: 20,
                  ),
                  ContentText(text: widget.category),
                ],
              ),
              Expanded(
                flex: 14,
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade300),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                          child: ContentText(text: widget.description)),
                    )),
              ),

              const Spacer(),

              Row(
                children: [
                  ContentText(text: "$commentCount نظریه"),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CommentScreen(productId: widget.productId),
                              ),
                            );
                          },
                          icon: const Icon(Icons.comment)),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('likes')
                            .doc(widget.productId)
                            .collection('users')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading...');
                          }
                          int likeCount = snapshot.data?.docs.length ?? 0;
                          return Text('Likes: $likeCount');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: isLiked ? Colors.blue : null,
                        ),
                        onPressed: toggleLike,
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('dislikes')
                            .doc(widget.productId)
                            .collection('users')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading...');
                          }
                          int dislikeCount = snapshot.data?.docs.length ?? 0;
                          return Text('disLikes: $dislikeCount');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isDisliked
                              ? Icons.thumb_down
                              : Icons.thumb_down_outlined,
                          color: isDisliked ? Colors.red : null,
                        ),
                        onPressed: toggleDislike,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.phone),
                    onPressed: () =>
                        LikeDislikeCounter.makePhoneCall(widget.numberPhone),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.blue, // <-- Button color
                      foregroundColor: Colors.red, // <-- Splash color
                    ),
                    label: const ContentText(text: 'تماس '),
                  ))
              // Display both like and dislike counts
            ],
          ),
        ),
      ),
    );
  }
}
