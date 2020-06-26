import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BeehiveItem extends StatefulWidget {
  @override
  _BeehiveItemState createState() => _BeehiveItemState();
}

class _BeehiveItemState extends State<BeehiveItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xff980101),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
          width: size.width - 85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xff707070), width: 1.5),
          ),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Stockwaage 1',
                    style: TextStyle(
                      fontFamily: 'bahnschrift',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xff6A6A6A),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Status: ',
                        style: TextStyle(
                          fontFamily: 'century gothic',
                          fontSize: 14,
                          color: Color(0xff6A6A6A),
                        ),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                          fontFamily: 'century gothic',
                          fontSize: 16,
                          color: Color(0xff00751B),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: Container(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onPressed: () => {},
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
