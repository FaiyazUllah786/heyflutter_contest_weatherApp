import 'package:flutter/material.dart';

class MoreInfo extends StatelessWidget {
  final IconData icon;
  final String infoName;
  final String infoData;
  const MoreInfo({
    super.key,
    required this.icon,
    required this.infoName,
    required this.infoData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 35,
        ),
        Text(
          infoName,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        Text(
          infoData,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
