import 'package:flutter/material.dart';

class CloudIcon extends StatelessWidget {
  const CloudIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.white,
          width: 8,
          height: 8,
        ),
        const Icon(
          Icons.cloud_done_sharp,
          size: 20,
          color: Colors.purple,
        ),
      ],
    );
  }
}
