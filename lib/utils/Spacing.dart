import 'package:flutter/material.dart';

class Spacing extends StatelessWidget {
  final bool vertical;

  const Spacing({
    Key? key,
    required this.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return vertical
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          );
  }
}