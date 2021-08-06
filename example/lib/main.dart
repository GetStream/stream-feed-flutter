import 'package:example/app_user.dart';
import 'package:example/client_provider.dart';
import 'package:example/extension.dart';
import 'package:example/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const _key = String.fromEnvironment('key');
  const _userToken = String.fromEnvironment('user_token');
  final client = StreamFeedClient.connect(
    _key,
    token: const Token(_userToken),
  );
  runApp(
    MyApp(
      client: client,
    ),
  );
}

//ignore: public_member_api_docs
class MyApp extends StatelessWidget {
  //ignore: public_member_api_docs
  const MyApp({
    required this.client,
    Key? key,
  }) : super(key: key);

  //ignore: public_member_api_docs
  final StreamFeedClient client;

  @override
  //ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Feed Demo',
      home: const LoginScreen(),
      builder: (context, child) => ClientProvider(
        client: client,
        child: child!,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamFeedClient>('client', client));
  }
}

//ignore: public_member_api_docs
class LoginScreen extends StatefulWidget {
  //ignore: public_member_api_docs
  const LoginScreen({Key? key}) : super(key: key);
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login with a User',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 42),
              for (final user in appUsers)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: RaisedButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Loading User'),
                        ),
                      );
                      final streamUser = await _client.user(user.id).create(
                            user.data,
                            getOrCreate: true,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 36, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.blue,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios)
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
