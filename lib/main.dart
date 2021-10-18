// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'beer_model.dart';
import 'beer_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        // Add the 3 lines from here...
        primarySwatch: Colors.green,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final BeerService beerService = BeerService();
  final _beers = <Beer>[];
  final _saved = <Beer>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildRow(Beer beer) {
    final alreadySaved = _saved.contains(beer);
    return ListTile(
        title: Text(
          beer.name,
          style: _biggerFont,
        ),
        trailing: Icon(
          // NEW from here...
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ), // ... to here.
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(beer);
            } else {
              _saved.add(beer);
            }
          });
        });
  }

  Widget _buildSuggestions(List<Beer> beers) {
    _beers.addAll(beers);
    print(_beers.length);
    return ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: beers.length,
        itemBuilder: /*1*/ (context, i) {
          return _buildRow(_beers[i]);
        });
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (Beer beer) {
              return ListTile(
                title: Text(
                  beer.name,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: FutureBuilder<List<Beer>>(
          future: beerService.getBeers(),
          builder: (BuildContext context, AsyncSnapshot<List<Beer>> snapshot) {
            if (snapshot.hasData) {
              List<Beer>? beers = snapshot.data;
              print(beers);
              return _buildSuggestions(beers!);
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
