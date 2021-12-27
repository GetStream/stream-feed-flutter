import 'package:example/people_screen.dart';
import 'package:example/profile_screen.dart';
import 'package:example/timeline_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

//ignore: public_member_api_docs
class HomeScreen extends StatefulWidget {
  //ignore: public_member_api_docs
  const HomeScreen({
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  //ignore: public_member_api_docs
  final StreamUser currentUser;

  @override
  _HomeScreenState createState() => _HomeScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamUser>('currentUser', currentUser));
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  //ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.bike_scooter_rounded),
            SizedBox(width: 16),
            Text('Tweet It!'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          TimelineScreen(currentUser: widget.currentUser),
          ProfileScreen(currentUser: widget.currentUser),
          PeopleScreen(currentUser: widget.currentUser),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        elevation: 16,
        type: BottomNavigationBarType.fixed,
        iconSize: 22,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.timeline),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.supervised_user_circle_sharp),
            label: 'People',
          ),
        ],
      ),
    );
  }
}
