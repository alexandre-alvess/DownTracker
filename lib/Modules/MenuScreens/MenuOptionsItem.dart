import 'package:flutter/material.dart';

class MenuOptionsItem extends StatelessWidget {

  final Icon leading;
  final String title;
  final String subtitle;
  final bool danger;
  final Function onTrap;

  MenuOptionsItem({
    Key key,
    @required this.leading,
    @required this.title,
    @required this.subtitle,
    this.danger = false,
    @required this.onTrap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: this.onTrap,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[this.leading],
      ),
      title: Text(
        this.title,
        style: TextStyle(
          color: danger ? Colors.red : Colors.black87,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2
        ),
      ),
      subtitle: Text(
        this.subtitle,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 14.0,
          letterSpacing: 0.2
        ),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: danger ? Colors.red : Theme.of(context).primaryColor,
      ),
    );
  }
}