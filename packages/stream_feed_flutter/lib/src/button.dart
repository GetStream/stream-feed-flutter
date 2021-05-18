import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  Button({required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
        gradient: LinearGradient(
          // begin: Alignment.topCenter,
          // end: Alignment.bottomCenter,
          colors: [Color(0xFF00A1FF), Color(0xFF007AFF)],
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
