import 'package:flutter/material.dart';
import 'package:projects/Components/SearchButton.dart';
import 'package:projects/Components/Themebutton.dart';
import 'package:projects/Components/ColorButton.dart';
import 'package:projects/Constants.dart';
import 'package:projects/Screens/MainHome.dart';
import 'package:projects/Screens/MyListScreen.dart';
import 'package:projects/Screens/ProfileScreen.dart';
import 'package:projects/Screens/ScheduleScreen.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.changeTheme,
    required this.appTitle,
    required this.colorSelected,
    required this.changeColor,
  });

  final ColorSelection colorSelected;
  final void Function(int value) changeColor;
  final void Function(bool useLightMode) changeTheme;
  final String appTitle;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MainHome(),
    const Schedulescreen(),
    const MyListScreen(),
    const Profilescreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine contrasting color for BottomNavigationBar
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.appTitle)),
        backgroundColor: widget.colorSelected.color,
        leading: const SearchButton(),
        actions: [
          ThemeButton(
            changeThemeMode: widget.changeTheme,
          ),
          ColorButton(
            colorSelected: widget.colorSelected,
            changeColor: widget.changeColor,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        unselectedItemColor: isDark ? Colors.white : Colors.black,
        selectedItemColor: widget.colorSelected.color,
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "My List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
