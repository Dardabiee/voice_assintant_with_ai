import 'package:chat_assistant_ai/pallete.dart';
import 'package:flutter/material.dart';

class FeaturesBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeaturesBox({super.key, required this.color, required this.headerText, required this.descriptionText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, bottom: 20),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            Text(headerText, style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cera Pro',
              color: Pallete.blackColor
            )),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(descriptionText, style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Cera Pro',
                color: Pallete.blackColor
              )),
            )
          ],
        ),
      ),
    );
  }
}