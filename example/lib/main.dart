import 'package:example/dummy_app_user.dart';
import 'package:example/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:stream_feed_dart/stream_feed.dart';

import 'home.dart';

final locator = GetIt.instance;

void main() async {
  /// If you're running an application and need to access the binary messenger before `runApp()`
  /// has been called (for example, during plugin initialization), then you need to explicitly
  /// call the `WidgetsFlutterBinding.ensureInitialized()` first.
  /// If you're running a test, you can call the `TestWidgetsFlutterBinding.ensureInitialized()`
  /// as the first line in your test's `main()` method to initialize the binding.)
  WidgetsFlutterBinding.ensureInitialized();

  /// Forcing only portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final client = StreamClient.connect(
    '9wbdt7vucby6',
    'bksn37r6k7j5p75mmy6znts47j9f9pc49bmw3jjyd7rshg2enbcnq666d2ryfzs8',
  );

  locator.registerSingleton<StreamClient>(client);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Feed Demo',
      home: LoginScreen(),
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
    final client = locator<StreamClient>();
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
                            await ProgressDialogHelper.show(
                              context,
                              message: "Logging User...",
                            );
                            final streamUser = await client.users.add(
                              user.id,
                              user.data,
                              getOrCreate: true,
                            );
                            await ProgressDialogHelper.hide();
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
