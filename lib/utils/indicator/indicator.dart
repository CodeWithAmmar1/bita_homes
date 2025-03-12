import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  bool _isVisible = true;

  void disposeIndicator() {
    setState(() {
      _isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? CircularProgressIndicator(
            strokeWidth: 6,
            color: Colors.white,
          )
        : SizedBox(); // Empty widget when disposed
  }
}
