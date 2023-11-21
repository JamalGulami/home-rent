import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class LikeDislikeCounter {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getLikeCount(String productId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('likes')
        .where('productId', isEqualTo: productId)
        .where('type', isEqualTo: 'like')
        .get();

    return querySnapshot.docs.length;
  }

  Future<int> getDislikeCount(String productId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('likes')
        .where('productId', isEqualTo: productId)
        .where('type', isEqualTo: 'dislike')
        .get();

    return querySnapshot.docs.length;
  }

  static String timeAgoFromTimestamp(Timestamp timestamp) {
    final now = Timestamp.now();
    final difference = now.toDate().difference(timestamp.toDate());

    // if(difference.inDays >6){
    //   return 'alj';
    // }

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'یک روز پیش';
      } else {
        return '${difference.inDays} روز پیش';
      }
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) {
        return '1 ساعت پیش';
      } else {
        return '${difference.inHours} ساعت پیش';
      }
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) {
        return 'یک دقیقه پیش';
      } else {
        return '${difference.inMinutes} دقیقه پیش';
      }
    } else {
      return 'حالا';
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
