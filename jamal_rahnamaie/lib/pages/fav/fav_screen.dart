import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jamal_rahnamaie/models/fav_model.dart';
import 'package:jamal_rahnamaie/pages/detailsproducts/details_products.dart';
import 'package:jamal_rahnamaie/widgets/boxes.dart';
import 'package:jamal_rahnamaie/widgets/subtext.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  FavScreenState createState() => FavScreenState();
}

class FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: ContentText(text: 'علاقه مندی ها'),
      ),
      body: ValueListenableBuilder<Box<FavModel>>(
        valueListenable: Boxes.getHistory().listenable(),
        builder: (context, box, _) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                final product = box.getAt(index)!;
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsDetails(
                            title: product.title,
                            description: product.description,
                            category: product.category,
                            imageUrl: product.imageUrl,
                            productId: product.productId,
                            numberPhone: "",
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
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
                                      child: product.imageUrl.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  10), // Adjust the radius as needed
                                              child: CachedNetworkImage(
                                                imageUrl: product.imageUrl,
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
                                            text: product.title,
                                            size: 18.0,
                                          ),
                                          SingleChildScrollView(
                                            child: Text(
                                              product.description,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontFamily: 'ir',
                                                  fontSize: 16.0,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                          //const Spacer(),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ));
              });
        },
      ),
    );
  }
}
