import 'package:flutter/material.dart' hide Router;
import 'package:jamal_rahnamaie/pages/about/about_us.dart';
import 'package:jamal_rahnamaie/utils/appconstent.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.zero,
        children: [
          _createHeader(),
          _createDrawerItem(
              icon: Icons.account_box,
              text: 'درباره ما',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsScreen()));
              }),
          _createDrawerItem(
              icon: Icons.phone,
              text: 'تماس با ما',
              onTap: () {
                LikeDislikeCounter.makePhoneCall('0728100892');
              }),
          const Divider(),
          const Divider(),
          ListTile(
            title: const Text('خروج'),
            onTap: () async {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return const DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/login.png'))),
        child: Stack(children: [
          Positioned(bottom: 12.0, left: 16.0, child: SizedBox()),
        ]));
  }

  Widget _createDrawerItem(
      {IconData? icon, required String text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              text,
              style: const TextStyle(fontFamily: 'iran'),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
