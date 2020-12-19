import 'dart:io';

import 'package:flutter/material.dart';

class GifListView extends StatelessWidget {
  final List<String> _generatedGifPaths;

  const GifListView({
    Key key,
    @required List<String> generatedGifPaths,
  })  : _generatedGifPaths = generatedGifPaths,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return _generatedGifPaths.isEmpty
        ? Center(
            child: Text('You have not created any GIF yet 🙁'),
          )
        : GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: _generatedGifPaths.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 8,
                child: Image.file(
                  File(
                    _generatedGifPaths.elementAt(index),
                  ),
                ),
              );
            },
          );
  }
}
