import 'package:example/people_screen.dart';
import 'package:example/profile_screen.dart';
import 'package:example/timeline_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

class HomeScreen extends StatefulWidget {
  final User streamUser;

  const HomeScreen({Key? key, required this.streamUser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.bike_scooter_rounded),
            SizedBox(width: 16),
            Text('Tweet It!'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          TimelineScreen(streamUser: widget.streamUser),
          ProfileScreen(streamUser: widget.streamUser),
          PeopleScreen(streamUser: widget.streamUser),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        elevation: 16.0,
        type: BottomNavigationBarType.fixed,
        iconSize: 22,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
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
