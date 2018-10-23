import 'package:flutter/material.dart';
import 'package:chyy_app/common/style/theme.dart';

class LKTTabButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final bool active;
  final Map<String, Color> activeColor;
  final Map<String, Color> deActiveColor;
  Color color;
  Color textColor;
  LKTTabButton({this.text, this.callback, this.active = false, this.activeColor = const {'color': AppTheme.main_color, 'textColor': Colors.white}, this.deActiveColor = const {'color': Colors.white, 'textColor': AppTheme.main_color}});
  @override
  Widget build(BuildContext context) {
    color = active ? activeColor["color"] : deActiveColor["color"];
    textColor = active ? activeColor["textColor"] : deActiveColor["textColor"];
    return new Container(
      margin: EdgeInsets.all(5.0),
      child: new MaterialButton(
        color: color,
        textColor: textColor,
        onPressed: callback,
        child: new Text(text),
      ),
    );
  }
}
class LKTTabButtonFlat extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final bool active;
  final Map<String, Color> activeColor;
  final Map<String, Color> deActiveColor;
  Color color;
  Color textColor;
  LKTTabButtonFlat({this.text, this.callback, this.active = false, this.activeColor = const {'color': AppTheme.main_color, 'textColor': Colors.white}, this.deActiveColor = const {'color': Colors.white, 'textColor': AppTheme.main_color}});
  @override
  Widget build(BuildContext context) {
    color = active ? activeColor["color"] : deActiveColor["color"];
    textColor = active ? activeColor["textColor"] : deActiveColor["textColor"];
    return new Container(
      child: new FlatButton(
        color: color,
        textColor: textColor,
        onPressed: callback,
        child: new Text(text),
      ),
    );
  }
}