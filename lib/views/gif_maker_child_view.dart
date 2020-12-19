import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gif_maker/views/gif_maker_main_view.dart';

import 'package:gif_maker/views/video_player_view.dart';

class GifMakerChildView extends StatelessWidget {
  final String _fileToDisplayPath;
  final NatureOfFile _natureOfFile;
  final Function _onUploadVideoPressed;
  final Function _onConvertGifPressed;
  const GifMakerChildView({
    Key key,
    @required String fileToDisplay,
    @required Function onUploadVideoPresesed,
    @required Function onConvertGifPressed,
    @required NatureOfFile natureOfFile,
  })  : _fileToDisplayPath = fileToDisplay,
        _onConvertGifPressed = onConvertGifPressed,
        _onUploadVideoPressed = onUploadVideoPresesed,
        _natureOfFile = natureOfFile,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.center,
            child: Card(
              elevation: 8,
              child: Padding(
                  padding: const EdgeInsets.all(8), child: _buildFileView()),
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: _imageSelectButton(),
                  ),
                ),
                Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: _convertToGifButton()),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildFileView() {
    switch (_natureOfFile) {
      case NatureOfFile.Asset:
        return Image.asset(_fileToDisplayPath);

      case NatureOfFile.Gif:
        return Image.file(File(_fileToDisplayPath));

      case NatureOfFile.Vidoe:
        return VideoPlayerView(
          vidoeFile: File(_fileToDisplayPath),
        );

      case NatureOfFile.Identifying:
        return CircularProgressIndicator();

      default:
        return Center(
          child: Text('File type not provided'),
        );
    }
  }

  Widget _imageSelectButton() {
    return SizedBox(
      width: 150,
      child: RaisedButton(
        onPressed: _onUploadVideoPressed,
        child: Text('Upload Video'),
      ),
    );
  }

  Widget _convertToGifButton() {
    return SizedBox(
      width: 150,
      child: RaisedButton(
        onPressed: _onConvertGifPressed,
        child: Text('Convert To GIF'),
      ),
    );
  }
}
