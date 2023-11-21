import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamal_rahnamaie/pages/userlogin/firebase_auth.dart'; // Replace with your login page

class LogoutPage extends StatelessWidget {
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error occurred during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'آیا مطمئن هستید که ازبرنامه خارج شوید؟',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _logout().then((_) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AuthPage()),
                    (route) => false,
                  );
                });
              },
              child: Text('بله'),
            ),
          ],
        ),
      ),
    );
  }
}
