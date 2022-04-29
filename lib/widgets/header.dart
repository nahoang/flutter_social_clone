import 'package:flutter/material.dart';

AppBar header(context, { bool isAppTitle = false, String titleText = '',
  removeBackbutton = false }) {
  return AppBar(
    automaticallyImplyLeading: removeBackbutton ? false : true,
    title: Text(
      isAppTitle ? 'Flutter social' : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ?  'Signatra' : '',
        fontSize: isAppTitle ? 50.0 : 22.0
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
