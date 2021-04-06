import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SwipeToDismiss extends StatelessWidget {
  final bool secondary;
  final bool margin;
  final func;
  final Widget child;
  SwipeToDismiss({this.secondary,this.func,this.child,this.margin=false});

  Widget bG(alignment,icon, color){
    return Container(
      margin: margin ? EdgeInsets.symmetric(vertical: 16,) : null,
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 25),
      alignment: alignment,
      child: Icon(
       icon,
        color: Colors.white,
      ),
    );
  }

  Widget primaryBg(secondary) {
    return bG(
        secondary
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        Icons.delete,
        Colors.red);
  }

  Widget secondaryBg() {
    return bG(
        AlignmentDirectional.centerEnd,
        margin ? FontAwesomeIcons.check: Icons.edit,
        margin ? Colors.green : Colors.amber[700]);
  }

  @override
    Widget build(BuildContext context) {
      return Dismissible(
          key: UniqueKey(),
          background: primaryBg(false),
          secondaryBackground: secondary ? secondaryBg() : primaryBg(true),
//          onDismissed: func,
          confirmDismiss: func,
          child:child
      );
    }
}
