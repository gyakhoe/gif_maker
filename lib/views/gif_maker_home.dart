import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gif_maker/views/video_player_view.dart';
import 'package:image_picker/image_picker.dart';

class GifMakerHome extends StatefulWidget {
  @override
  _GifMakerHomeState createState() => _GifMakerHomeState();
}

class _GifMakerHomeState extends State<GifMakerHome> {
  File video;
  ImagePicker imagePicker;

  bool isVideoSelected;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    isVideoSelected = false;
  }

  @override
  void dispose() {
    video = null;
    imagePicker = null;
    isVideoSelected = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gif Maker'),
        ),
        body: isVideoSelected
            ? Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: VideoPlayerView(
                            vidoeFile: video,
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.center,
                        child: _imageSelecteButton()),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: _convertToGifButton()),
                  ),
                ],
              )
            : Center(
                child: _imageSelecteButton(),
              ),
      ),
    );
  }

  Widget _imageSelecteButton() {
    return RaisedButton(
      onPressed: () {
        imagePicker.getVideo(source: ImageSource.gallery).then((pickedFile) {
          print('Selcted file is in - ${pickedFile.path}');

          setState(() {
            video = File(pickedFile.path);
            isVideoSelected = true;
          });
        });
      },
      child: Text('Click to select video from Gallery'),
    );
  }

  Widget _convertToGifButton() {
    return RaisedButton(
      onPressed: null,
      child: Text('Convert to GIF'),
    );
  }
}
