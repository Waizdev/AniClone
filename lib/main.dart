import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projects/Screens/homescreen.dart';
import 'package:projects/Constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const AniClone());
}

class AniClone extends StatefulWidget {
  const AniClone({super.key});

  @override
  State<AniClone> createState() => _AniCloneState();
}

class _AniCloneState extends State<AniClone> {
  final appTitle = "Aniclone";

  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.green;

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void changeColor(int value) {
    setState(() {
      colorSelected = ColorSelection.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: Home(
        changeTheme: changeThemeMode,
        changeColor: changeColor,
        colorSelected: colorSelected,
        appTitle: appTitle,
      ),
    );
  }
}
