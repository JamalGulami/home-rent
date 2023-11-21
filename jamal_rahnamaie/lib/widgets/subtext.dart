import 'package:flutter/material.dart';

class ContentText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final String fontfamily;
  const ContentText({
    Key? key,
    this.size = 16.0,
    required this.text,
    this.fontfamily = 'ir',
    this.color = Colors.black,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: color,
        fontFamily: fontfamily,
        fontSize: size,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
