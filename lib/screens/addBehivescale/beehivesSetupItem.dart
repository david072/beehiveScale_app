import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BeehiveScaleSetupItem {
  TextEditingController nameController;

  Color pickerColor = Color(0xff);
  Color textColor = Color(0xff959595).withOpacity(0.8);

  String name = '';
  final int index;
  Color color;
  final BuildContext context;

  BeehiveScaleSetupItem({this.index = 1, this.context}) {
    initialColor();
    setTextColor();
    nameController =
        TextEditingController(text: 'Stockwaage ' + index.toString());
    name = 'Stockwaage ' + index.toString();
  }

  String getName() {
    print(name);
    return name;
  }

  String getColorAsInt() {
    return color.value.toString();
  }

  void initialColor() {
    Random rand = Random();
    int length = 6;
    String chars = '0123456789ABCDEF';
    String hex = '0xff';
    while (length-- > 0) hex += chars[(rand.nextInt(16)) | 0];

    color = Color(int.parse(hex));
    pickerColor = color;
  }

  void changeColor(Color color) {
    pickerColor = color;
  }

  void onFinished() {
    color = pickerColor;
    setTextColor();
    Navigator.of(context).pop();
  }

  double brightness(Color color) {
    int red = color.red;
    int green = color.green;
    int blue = color.blue;

    return sqrt(
        red * red * 0.241 + green * green * 0.691 + blue * blue * 0.068);
  }

  void setTextColor() {
    double b = brightness(color);
    if (b > 130) {
      textColor = Color(0xff000000).withOpacity(0.8);
    } else if (b <= 130) {
      textColor = Color(0xffFFFFFF).withOpacity(0.8);
    }
  }

  Widget getWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: nameController,
            onChanged: (String newName) => name = newName,
            validator: (input) {
              if (input.isEmpty) {
                return 'Bitte gib einen Namen an.';
              }

              return null;
            },
            decoration: InputDecoration(
              hintText: 'Name der Stockwaage',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff008F26),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(200),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff008F26),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(200),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  'Farbe:',
                  style: TextStyle(
                    fontFamily: 'century gothic',
                    fontSize: 22,
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(400),
                  ),
                  color: color,
                  child: Text(
                    'Color-Picker öffnen',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff959595).withOpacity(0.8),
                    ),
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text('Wähle eine Farbe aus!'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: pickerColor,
                          onColorChanged: changeColor,
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Fertig!'),
                          onPressed: () => {
                            onFinished(),
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
