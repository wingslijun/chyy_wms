import 'package:flutter/material.dart';

/// 带图标的输入框
class LKTIconInputWidget extends StatefulWidget {
  final bool obscureText;

  final String hintText;

  final IconData iconData;

  final ValueChanged<String> onChanged;

  final TextStyle textStyle;

  final TextEditingController controller;

  LKTIconInputWidget({Key key, this.hintText, this.iconData, this.onChanged, this.textStyle, this.controller, this.obscureText = false}) : super(key: key);

  @override
  _LKTIconInputWidgetState createState() => new _LKTIconInputWidgetState(hintText, iconData, onChanged, textStyle, controller, obscureText);
}

/// State for [LKTIconInputWidget] widgets.
class _LKTIconInputWidgetState extends State<LKTIconInputWidget> {
  final bool obscureText;

  final String hintText;

  final IconData iconData;

  final ValueChanged<String> onChanged;

  final TextStyle textStyle;

  final TextEditingController controller;

  _LKTIconInputWidgetState(this.hintText, this.iconData, this.onChanged, this.textStyle, this.controller, this.obscureText) : super();

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: new InputDecoration(
        hintText: hintText,
        icon: iconData == null ? null : new Icon(iconData),
      ),
    );
  }
}
