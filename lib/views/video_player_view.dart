

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final File vidoeFile;
  const VideoPlayerView({
    Key? key,
    required this.vidoeFile,
  }) : super(key: key);
  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;
  Future<void>? _initializedVideoPlayerFuture;
  IconData? _videoControllButton;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(widget.vidoeFile);
    _initializedVideoPlayerFuture = _controller.initialize();
    _controller.addListener(_videoControllerListener);
    _videoControllButton = Icons.play_arrow;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _videoControllerListener() {
    setState(() {
      if (_controller.value.isPlaying) {
        _videoControllButton = Icons.pause;
      } else {
        if (_controller.value.position == _controller.value.duration) {
          _controller.seekTo(Duration(seconds: 0));
          _controller.pause();
        }
        _videoControllButton = Icons.play_arrow;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializedVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              IconButton(
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
                icon: Icon(_videoControllButton),
                iconSize: 50,
                color: Colors.red,
              ),
            ],
          );
        } else {
          return (Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
