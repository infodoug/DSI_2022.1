// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  int _viewNumber = 0;

  chooseView(choosenMode) {
    if (choosenMode == 0) {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          final alreadySaved = _saved.contains(_suggestions[index]);
          return ListTile(
              title: Text(
                _suggestions[index].asPascalCase,
                style: _biggerFont,
              ),
              trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              ),
              onTap: () {
                // NEW from here ...
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(_suggestions[index]);
                  } else {
                    _saved.add(_suggestions[index]);
                  }
                }); // to here.
              });
        },
      );
    }
    if (choosenMode == 1) {
      return GridView.builder(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        // Generate 100 widgets that display their index in the List.
        //itemCount: _suggestions.length,
        itemBuilder: (context, i) {
          final index = i;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }

          final alreadySaved = _saved.contains(_suggestions[index]);
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                height: 220,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      Expanded(
                          child: Align(
                        child: IconButton(
                          icon: Icon(
                            alreadySaved
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          color: alreadySaved ? Colors.red : null,
                          tooltip: alreadySaved ? 'Remove from saved' : 'Save',
                          onPressed: (() {
                            setState(() {
                              if (alreadySaved) {
                                _saved.remove(_suggestions[index]);
                              } else {
                                _saved.add(_suggestions[index]);
                              }
                            });
                          }),
                        ),
                        alignment: Alignment.topRight,
                      )),
                      Expanded(
                          child: Align(
                        child: Text(
                          _suggestions[index].asPascalCase,
                          style: _biggerFont,
                        ),
                        alignment: Alignment.center,
                      )),
                      Expanded(child: Container())
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _pushSaved() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_carousel),
            onPressed: () {
              if (_viewNumber == 0) {
                setState(() {
                  _viewNumber++;
                });
              } else if (_viewNumber == 1) {
                setState(() {
                  _viewNumber--;
                });
              }
            },
            tooltip: 'Change to Card View',
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          )
        ],
      ),
      body: chooseView(_viewNumber),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}
