import 'package:flutter/material.dart';
import 'package:gif_maker/views/gif_list_view.dart';
import 'package:gif_maker/views/gif_maker_main_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex;
  List<Widget> views;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    views = [GifMakerMainView(), GifListView()];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gif Maker'),
        ),
        body: views.elementAt(_selectedIndex),
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
}
