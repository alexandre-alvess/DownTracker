
import 'package:flutter/material.dart';

class DownAppBar {
  static PreferredSize build({
    IconButton leading,
    IconButton action,
    Widget title
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(65.0),
      child: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.only(
            top: 36.0,
            left: 12.0,
            right: 12.0,
            bottom: 12.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(child: leading)
              ),
              Expanded(
                flex: 4,
                child: Container(
                  alignment: Alignment.center,
                  child: title
                )
              ),
              Expanded(
                flex: 1,
                child: Container(child: action),
              ),
            ],
          ),
        ),
      ),
    );
  }
}