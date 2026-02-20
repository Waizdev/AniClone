import 'package:flutter/material.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),leading: Icon(Icons.add_a_photo_outlined),),
      body: ListView.builder(itemBuilder: (context, index) {return ListTile();} ,)
    );
  }
}