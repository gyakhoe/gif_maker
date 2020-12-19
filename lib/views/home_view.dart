import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gif_maker/views/gif_list_view.dart';
import 'package:gif_maker/views/gif_maker_main_view.dart';
import 'package:path_provider/path_provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex;
  List<Widget> views;
  List<String> generatedGifs;
  Directory gifDirectory;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    generatedGifs = [];
    views = [];
    _loadRequiredData();
  }

  void _loadRequiredData() {
    getApplicationDocumentsDirectory().then((directory) {
      gifDirectory = Directory(directory.path + '/gif');
      gifDirectory.exists().then((exists) {
        if (!exists) {
          gifDirectory.create();
        } else {
          List<String> avilableGifs = [];
          gifDirectory.list().listen((file) {
            print('gif found here');
            File(file.path).length().then((value) {
              if (value > 0) {
                avilableGifs.add(file.path);
              }
            });
          }).onDone(() {
            setState(() {
              generatedGifs = avilableGifs;
              views = [
                GifMakerMainView(
                  onGifGenerateCallback: _onGifGenerated,
                  gifDirectory: gifDirectory,
                ),
                GifListView(
                  generatedGifPaths: generatedGifs,
                )
              ];
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gif Maker'),
        ),
        body: views.isEmpty
            ? Center(child: Text('Populating Views'))
            : views.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Theme.of(context).primaryColor,
          currentIndex: _selectedIndex,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: Colors.pink,
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.gif_rounded,
                size: 40,
              ),
              label: 'GIF',
            ),
          ],
        ),
      ),
    );
  }

  void _onGifGenerated() async {
    print('we are here in onGifGenerated');
    List<String> avilableGifs = [];
    gifDirectory.list().listen((file) {
      print('gif found here');
      File(file.path).length().then((value) {
        if (value > 0) {
          avilableGifs.add(file.path);
        }
      });
    }).onDone(() {
      generatedGifs = avilableGifs;
      setState(() {
        views.removeAt(1);
        views.insert(
            1,
            GifListView(
              generatedGifPaths: generatedGifs,
            ));
      });
    });
  }
}
