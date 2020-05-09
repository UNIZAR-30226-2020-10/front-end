


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tuneit/widgets/AutoScrollableText.dart';

Widget iconText (BuildContext context,String text, IconData ic) {
  return Row(
    children: <Widget>[
      SizedBox(width: 10,),
      Icon(ic, size: 20,),
      SizedBox(width: 10,),
      Expanded(
        child: MarqueeWidget(
          child: Text(text, style: Theme.of(context).textTheme.body1,),
        ),
      )
    ],
  );
}