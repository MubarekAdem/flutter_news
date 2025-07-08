import 'package:flutter/material.dart';
import 'news_screen.dart';
import 'travel_screen.dart';
import 'weather_screen.dart';
import 'finance_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const NewsScreen(),
    const TravelScreen(),
    const WeatherScreen(),
    const FinanceScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Travel'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Weather'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Finance',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
