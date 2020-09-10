import 'package:flutix/shared/theme.dart';
import 'package:flutter/material.dart';

class SelectableBox extends StatelessWidget {
  final bool isSelected;
  final bool isEnabled;
  final double width;
  final double height;
  final String text;
  final Function onTap;
  final TextStyle textStyle;

  SelectableBox(
    this.text,
    {this.isSelected = false,
    this.isEnabled = true,
    this.width = 145,
    this.height = 50,
    this.onTap,
    this.textStyle}
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(this.text);
        }
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: (!isEnabled)
                ? Color(0xFFE4E4E4)
                : (isSelected ? accentColor2 : Colors.transparent),
            border: Border.all(
              color: (!isEnabled)
                ? Color(0xFFE4E4E4)
                : (isSelected ? Colors.transparent : Color(0xFFDCDCDC))
            )
        ),
        child: Center(
          child: Text(
            text ?? "None",
            style: (textStyle ?? blackTextFont).copyWith(
              fontSize: 16, 
              fontWeight: FontWeight.normal, 
              color: isEnabled ? Colors.black : Colors.grey
            ),
          ),
        ),
      )
    );
  }
}
