// category_screen.dart

import 'package:flutter/material.dart';
import 'package:jamal_rahnamaie/widgets/subtext.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<String> categories = [
    'خانه های فروشی',
    'خانه های کرایی',
    'خانه های گیروی',
    'شبانه روزی'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const ContentText(text: 'کتگوری ها'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: ContentText(text: categories[index]),
            onTap: () {
              Navigator.pop(context, categories[index]);
            },
          );
        },
      ),
    );
  }
}
