//TODO: improve this
import 'package:flutter/material.dart';

class ProgressStateWidget extends StatelessWidget {
  const ProgressStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
