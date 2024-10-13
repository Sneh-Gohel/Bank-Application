import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AllFoldersList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AllFoldersList();
}

class _AllFoldersList extends State<AllFoldersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'Folder',
          child: Lottie.asset(
            'assets/lotties/folderAnimation.json',
            width: 250, // Adjust width as needed
            height: 250, // Adjust height as needed
            fit: BoxFit.fill,
            repeat: true, // Do not repeat the animation automatically
          ),
        ),
      ),
    );
  }
}
