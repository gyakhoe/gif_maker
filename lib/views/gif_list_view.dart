import 'package:flutter/material.dart';

class GifListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Image.asset('assets/images/photo-placeholder-250.png');
      },
    );
  }
}
