import 'package:flutter/material.dart';

class AddActivityDialog extends StatefulWidget {
  @override
  _AddActivityDialogState createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  final _activityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _activityController,
              decoration: const InputDecoration(
                hintText: "What's happening?",
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            RaisedButton(
              onPressed: () {
                final message = _activityController.text;
                Navigator.pop<String>(context, message);
              },
              color: Colors.blue,
              child: Text(
                'POST ACTIVITY',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
