import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:gif_maker/views/gif_maker_child_view.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class GifMakerMainView extends StatefulWidget {
  final String assetImagePath = 'assets/images/photo-placeholder-250.png';
  @override
  _GifMakerMainState createState() => _GifMakerMainState();
}

enum NatureOfFile { Vidoe, Asset, Gif, Identifying }

class _GifMakerMainState extends State<GifMakerMainView> {
  String _filePath;
  NatureOfFile _fileType;
  Directory gifDirectory;
  FlutterFFmpeg _flutterFFmpeg;

  @override
  void initState() {
    super.initState();

    _filePath = widget.assetImagePath;

    _fileType = NatureOfFile.Asset;
    _flutterFFmpeg = FlutterFFmpeg();
    getApplicationDocumentsDirectory().then((value) {
      gifDirectory = Directory(value.path + '/gif');
      gifDirectory.exists().then((exists) {
        if (!exists) {
          print('Gif directory not available. Creating one');
          gifDirectory.create();
        } else {
          print('Gif directory path ${gifDirectory.path}');
          print('Directory available');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GifMakerChildView(
      fileToDisplay: _filePath,
      onConvertGifPressed: _onConvertGifPressed,
      onUploadVideoPresesed: _onUplaodVideoPressed,
      natureOfFile: _fileType,
    );
  }

  void _onUplaodVideoPressed() {
    print('Upload video activity here');
    setState(() {
      _fileType = NatureOfFile.Identifying;
    });
    ImagePicker().getVideo(source: ImageSource.gallery).then((selectedVideo) {
      setState(() {
        if (selectedVideo != null) {
          _filePath = selectedVideo.path;
          print(_filePath);
          _fileType = NatureOfFile.Vidoe;
        } else {
          _filePath = widget.assetImagePath;
          _fileType = NatureOfFile.Asset;
          _showErrorSnackBar(
            errorMessage: 'Filed to upload video',
          );
        }
      });
    });
  }

  void _onConvertGifPressed() async {
    print('Convert to gif here');

    if (_fileType == NatureOfFile.Gif || _fileType == NatureOfFile.Asset) {
      print('we are here');
      _showErrorSnackBar(errorMessage: 'Upload Video First');
    } else {
      setState(() {
        _fileType = NatureOfFile.Identifying;
      });
      final gifOutputFile = gifDirectory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.gif';
      print('Gif out file $gifOutputFile');
      final arguments = [
        '-i',
        _filePath,
        '-t',
        '2.5',
        '-ss',
        '2.0',
        '-f',
        'gif',
        gifOutputFile,
      ];

      _flutterFFmpeg.executeWithArguments(arguments).then((result) {
        setState(() {
          if (result == 0) {
            _filePath = gifOutputFile;
            _fileType = NatureOfFile.Gif;
          } else {
            _filePath = widget.assetImagePath;
            _fileType = NatureOfFile.Asset;
            _showErrorSnackBar(
                errorMessage: 'Filed to generate GIF. Try Again');
          }
        });
      });
    }
  }

  void _showErrorSnackBar({
    @required String errorMessage,
  }) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text(errorMessage),
        ],
      ),
    ));
  }
}
