import 'package:example/app_user.dart';
import 'package:example/client_provider.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

import 'client_provider.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //final _key = String.fromEnvironment('key');
  const _key = 'bm9v8gfybkht';
  //final _user_token = String.fromEnvironment('user_token');
  const _user_token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZ3Jvb3ZpbiJ9.6uMlHDLHpiHubWbcTztZO7NbFFZozuhwgNdrGgObgTE';
  final client = StreamFeedClient.connect(_key, token: Token(_user_token));
  runApp(
    MyApp(
      client: client,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.client}) : super(key: key);
  final StreamFeedClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Feed Demo',
      home: LoginScreen(),
      builder: (context, child) =>
          ClientProvider(client: client, child: child!),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _client = context.client;
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login with a User',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 42),
              for (final user in appUsers)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Loading User'),
                        ),
                      );
                      final streamUser = await _client.user(user.id).create(
                            user.data,
                            getOrCreate: true,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User Loaded'),
                        ),
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(
                            currentUser: streamUser,
                          ),
                        ),
                      );
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 36.0, horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.blue,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
