import 'package:example/dummy_app_user.dart';
import 'package:example/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_feed_dart/stream_feed.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Forcing only portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final client = StreamClient.connect(
    '9wbdt7vucby6',
    secret: 'bksn37r6k7j5p75mmy6znts47j9f9pc49bmw3jjyd7rshg2enbcnq666d2ryfzs8',
  );

  runApp(
    MyApp(
      client: client,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, @required this.client}) : super(key: key);
  final StreamClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Feed Demo',
      home: LoginScreen(),
      builder: (context, child) => ClientProvider(client: client, child: child),
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
              ...DummyAppUser.values
                  .map((user) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Loading User'),
                              ),
                            );
                            final streamUser = await _client.users.add(
                              user.id,
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
                                  streamUser: streamUser,
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
                      ))
                  .toList(growable: false),
            ],
          ),
        ),
      ),
    );
  }
}
