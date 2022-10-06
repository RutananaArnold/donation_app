// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final String? label;
  final String? value;
  final FontWeight fontWeight;
  final double padding;
  final double textSize;
  final double elevation;
  const ProfileTile({
    Key? key,
    this.label,
    this.value,
    this.fontWeight = FontWeight.w500,
    this.padding = 10.0,
    this.textSize = 16,
    this.elevation = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Size  size = MediaQuery.of(context).size;
    return Card(
      elevation: elevation,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label!,
              style: TextStyle(
                  fontSize: textSize,
                  fontWeight: fontWeight,
                  color: Colors.black),
            ),
            Text(
              value ?? "no data",
              style: TextStyle(
                  fontSize: textSize,
                  fontWeight: fontWeight,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}