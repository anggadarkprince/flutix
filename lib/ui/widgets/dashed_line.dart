import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final double width;

  DashedLine(this.width);

  @override
  Widget build(BuildContext context) {
    int n = width ~/ 5;
    return Row(
      children: List.generate(
        n,
        (index) => (index % 2 == 0)
          ? Container(height: 2, width: width / n, color: Color(0xFFE4E4E4))
          : SizedBox(width: width / n)
      ),
    );
  }
}