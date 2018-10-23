import 'package:flutter/widgets.dart';

enum VisibilityFlag {
  visible,
  invisible,
  offscreen,
  gone,
}
class Visibility  extends StatelessWidget{
  final bool visible;
  final Widget child;
  final Widget removeChild;
  Visibility({
    @required this.child,
    @required this.visible,
  }) : this.removeChild = Container();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(visible ==true) {
      return child;
    }else if(visible == false) {
      return new IgnorePointer(
        ignoring: true,
          child: new Opacity(
              opacity: 0.0,
              child: child
          )
      );
    }else if(visible == VisibilityFlag.offscreen) {
      return new Offstage(
          offstage: true,
          child: child
      );
    }else{
      return removeChild;
    }
  }
}

