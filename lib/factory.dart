import 'package:flutter/material.dart';

Widget iconButton(
    {required Icon icon, required Text label, Function()? onPressed}) {
  return SizedBox(
    height: 50,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 80.0,
              child: icon,
            ),
            Expanded(
              child: Center(child: label),
            ),
            const SizedBox(width: 30),
          ],
        ),
      ),
    ),
  );
}
