import 'package:flutter/material.dart';
import 'package:jamal_rahnamaie/pages/fav/fav_screen.dart';
import 'package:jamal_rahnamaie/pages/home/home_screen.dart';
import 'package:jamal_rahnamaie/pages/listcatgory/catgory_list.dart';
import 'package:jamal_rahnamaie/pages/products/products_reg_screen.dart';
import 'package:jamal_rahnamaie/pages/userprofile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  final List<Widget> _children = [
    const Homescreen(),
    const ProductsRegistration(),
    const FavScreen(),
    const Listcatgory(),
    const ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black54,
        onTap: onTabTapped,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'خانه',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'ثبت آگهی',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'مورد علاقه',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rectangle_outlined),
            label: 'دسته بندی',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'پروفایل من',
          ),
        ],
      ),
    );
  }
}
