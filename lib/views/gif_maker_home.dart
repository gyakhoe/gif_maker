import 'package:flutter/material.dart';

class GifMakerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gif Maker'),
        ),
        body: Center(
          child: Text('Gif Maker'),
        ),
      ),
    );
  }
}
