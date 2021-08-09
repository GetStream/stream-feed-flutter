import 'package:flutter/material.dart';

//ignore: public_member_api_docs
class AddActivityDialog extends StatefulWidget {
  //ignore: public_member_api_docs
  const AddActivityDialog({Key? key}) : super(key: key);

  @override
  _AddActivityDialogState createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  final _activityController = TextEditingController();

  @override
  //ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _activityController,
              decoration: const InputDecoration(
                hintText: "What's happening?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final message = _activityController.text;
                Navigator.pop<String>(context, message);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: const Text(
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
