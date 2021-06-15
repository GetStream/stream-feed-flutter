import 'package:flutter/material.dart';

enum ButtonType { faded, info, primary } //TODO: info button

class Button extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonType type;
  Button({required this.label, required this.onPressed, required this.type});
  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return _GradientButton(onPressed: onPressed, label: label);
      case ButtonType.faded:
        return _BorderButton(onPressed: onPressed, label: label);
      default:
        return _GradientButton(onPressed: onPressed, label: label);
    }
  }
}

class _BorderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  const _BorderButton({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 30,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: BorderSide(color: Color(0xFF007AFF)),
            ),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String label;

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
