import 'package:flutter/material.dart';

class CustomEnumerationItem extends StatelessWidget {
  final String text;
  final bool withPadding;

  CustomEnumerationItem({this.text, this.withPadding = false});

  @override
  Widget build(BuildContext context) {
    return withPadding ? Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10, right: 8),
            width: 20,
            height: 2,
            color: Color(0xff3B3B3B),
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'segoe ui',
                fontSize: 20,
                color: Color(0xff707070),
              ),
            ),
          ),
        ],
      ),
    ) : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10, right: 8),
          width: 20,
          height: 2,
          color: Color(0xff3B3B3B),
        ),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'segoe ui',
              fontSize: 20,
              color: Color(0xff707070),
            ),
          ),
        ),
      ],
    );
  }
}
