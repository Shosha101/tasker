import 'package:flutter/material.dart';

AppBar buildAppBar() {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          Icons.menu,
          color: Color.fromRGBO(0, 128, 128, 1),
          size: 30,
        ),
        Container(
          width: 40,
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Row(
              children: [
                Image.asset(
                  width: 40,
                  height: 40,
                  'assets/images/photo.jpeg',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        )
      ],
    ),
    elevation: 1,
  );
}