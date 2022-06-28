import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(title: 'Animated List'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedListState> _firstListKey =
      GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _secondListKey =
      GlobalKey<AnimatedListState>();

  final List<String> _firstList = <String>[
    'Caelina Cicero',
    'Lupus Lucia',
    'Titianus Flavianus'
  ];
  final List<String> _secondList = <String>[
    'Iuvenalis Martina',
    'Domitia Faustus',
    'Florianus Balbus'
  ];

  String _latestRemove = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text(widget.title)),
      body: Column(
        children: <Widget>[
          Expanded(
            child: AnimatedList(
              key: _firstListKey,
              initialItemCount: _firstList.length,
              itemBuilder: (context, index, animation) =>
                  _buildItem(_firstList[index], animation),
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: _secondListKey,
              initialItemCount: _secondList.length,
              itemBuilder: (context, index, animation) =>
                  _buildItem(_secondList[index], animation),
            ),
          ),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildItem(String list, Animation<double> animation) => FadeTransition(
        opacity: animation,
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.abc)),
            title: Text(list),
          ),
        ),
      );

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: const Text('ACTION!'),
            onPressed: () {
              _removeItem();

              _insertItem();
            },
          ),
        ],
      ),
    );
  }

  void _insertItem() {
    if (_latestRemove.isNotEmpty) {
      _secondListKey.currentState!.insertItem(
        0,
        duration: const Duration(milliseconds: 750),
      );

      _secondList.insert(0, _latestRemove);

      _latestRemove = '';
    }
  }

  void _removeItem() {
    if (_firstList.isNotEmpty) {
      final int index = _firstList.length - 1;

      _latestRemove = _firstList.removeAt(index);

      _firstListKey.currentState!.removeItem(
        index,
        (context, animation) => _buildItem(_latestRemove, animation),
        duration: const Duration(milliseconds: 750),
      );
    }
  }
}
