import 'package:flutter/material.dart';

class HelpContactWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle baseTextStyle = TextStyle(
      fontSize: 14,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.phone, color: Colors.green),
        SizedBox(width: 10),
        Text(
          '¿Necesitas ayuda? Llama al ',
          style: baseTextStyle,
        ),
        Text(
          '73247035',
          style: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
