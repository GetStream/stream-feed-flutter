//TODO: improve this
import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.announcement,
            color: Colors.red,
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            'Sorry an error occured',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
