import 'package:flutter/material.dart';
import 'package:projects/Screens/searchfeed.dart'; // Make sure the path matches

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: 'Search Anime',
      onPressed: () {
        // Navigation logic inside the button
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchPage()),
        );
      },
    );
  }
}
