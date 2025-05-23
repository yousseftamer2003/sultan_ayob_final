import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

Widget buildClosedWrap(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(8),
    width: double.infinity,
    height: 100,
    decoration: const BoxDecoration(
      color: maincolor,
    ),
    child: const Row(
      children: [
        Icon(
          Icons.lock,
          color: Colors.white,
        ),
        Text(
          'we are closed now',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ],
    ),
  );
}
