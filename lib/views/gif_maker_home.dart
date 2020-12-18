import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:gif_maker/views/video_player_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class GifMakerHome extends StatefulWidget {
  @override
  _GifMakerHomeState createState() => _GifMakerHomeState();
}

class _GifMakerHomeState extends State<GifMakerHome> {
  File _video;
  ImagePicker _imagePicker;
  File _createdGif;

  bool _isVideoSelected;
  FlutterFFmpeg _flutterFFmpeg;

  bool _isGifGenerating;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _isVideoSelected = false;
    _flutterFFmpeg = FlutterFFmpeg();

    _isGifGenerating = false;
  }

  @override
  void dispose() {
    _video = null;
    _imagePicker = null;
    _isVideoSelected = null;
    _flutterFFmpeg = null;
    _createdGif = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gif Maker'),
        ),
        body: _isVideoSelected
            ? Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: VideoPlayerView(
                            vidoeFile: _video,
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
                    flex: 1,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: _convertToGifButton()),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: _isGifGenerating
                          ? CircularProgressIndicator()
                          : _createdGif == null
                              ? Container()
                              : Image.file(_createdGif),
                    ),
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
        setState(() {
          _isVideoSelected = false;
        });
        _imagePicker.getVideo(source: ImageSource.gallery).then((pickedFile) {
          setState(() {
            _video = File(pickedFile.path);
            _isVideoSelected = true;
          });
        });
      },
      child: Text('Click to select a video from Gallery'),
    );
  }

  Widget _convertToGifButton() {
    return RaisedButton(
      onPressed: () async {
        Directory appDirectory = await getApplicationDocumentsDirectory();
        Directory gifDirectory = Directory(appDirectory.path + '/gif');
        if (!await gifDirectory.exists()) {
          await gifDirectory.create();
        }

        final gifOutputFile = gifDirectory.path +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.gif';

        var arguments = [
          '-i',
          _video.path,
          '-t',
          '2.5',
          '-ss',
          '2.0',
          '-f',
          'gif',
          gifOutputFile,
        ];

        setState(() {
          _isGifGenerating = true;
        });

        int result = await _flutterFFmpeg.executeWithArguments(arguments);

        if (result == 0) {
          setState(() {
            _isGifGenerating = false;
            _createdGif = File(gifOutputFile);
          });
        } else {
          setState(() {
            _isGifGenerating = false;
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Error occured while generating your gif. Please try shorter file.'),
            ));
          });
        }
      },
      child: Text('Convert to GIF'),
    );
  }
}
