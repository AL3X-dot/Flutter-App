import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final saved_pairs = Set<WordPair>();

  Widget _buildRow(WordPair wordpair) {
    final saved = saved_pairs.contains(wordpair);
    return ListTile(
      title: Text(
        wordpair.asPascalCase,
        style: TextStyle(fontSize: 18),
      ),
      trailing: Icon(
        saved ? Icons.favorite : Icons.favorite_border,
        color: saved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (saved) {
            saved_pairs.remove(wordpair);
          } else {
            saved_pairs.add(wordpair);
          }
        });
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item) {
        if (item.isOdd)
          return Divider(
            color: Colors.purple,
            thickness: 0.2,
          );
        final index = item ~/ 2;
        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        final Iterable<ListTile> tiles =
            saved_pairs.map((WordPair wordpair) => ListTile(
                  title: Text(
                    wordpair.asPascalCase,
                    style: TextStyle(fontSize: 20),
                  ),
                ));
        final List<Widget> result =
            ListTile.divideTiles(context: context, tiles: tiles).toList();
        return Scaffold(
          appBar: AppBar(title: Text("Saved")),
          body: ListView(children: result,),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Word Pair Generator"),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildList(),
    );
  }
}
