

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:gif_maker/views/gif_maker_child_view.dart';

class GifMakerMainView extends StatefulWidget {
  final String assetImagePath = 'assets/images/photo-placeholder-250.png';
  final Directory? _gifDirectory;
  final Function _onGifGeneratecallback;

  const GifMakerMainView({
    Key? key,
    required Directory? gifDirectory,
    required Function onGifGenerateCallback,
  })  : _gifDirectory = gifDirectory,
        _onGifGeneratecallback = onGifGenerateCallback,
        super(key: key);
  @override
  _GifMakerMainState createState() => _GifMakerMainState();
}

enum NatureOfFile { Vidoe, Asset, Gif, Identifying }

class _GifMakerMainState extends State<GifMakerMainView> {
  String? _filePath;
  NatureOfFile? _fileType;
  late FlutterFFmpeg _flutterFFmpeg;

  @override
  void initState() {
    super.initState();
    _filePath = widget.assetImagePath;
    _fileType = NatureOfFile.Asset;
    _flutterFFmpeg = FlutterFFmpeg();
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
    ImagePicker().pickVideo(source: ImageSource.gallery).then((selectedVideo) {
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
      final gifOutputFile = widget._gifDirectory!.path +
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
            print('Gif created successfully');
            _filePath = gifOutputFile;
            _fileType = NatureOfFile.Gif;
            widget._onGifGeneratecallback();
          } else {
            print('GIF failed to create');
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
    required String errorMessage,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
