import 'dart:async';
import 'package:flutter/material.dart';

class Lista extends StatefulWidget {
  const Lista({Key? key});

  @override
  State<Lista> createState() => _ListaStreamsState();
}

class _ListaStreamsState extends State<Lista> {
  late StreamController<List<Map<String, dynamic>>> _streamController;
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _items = [];
    _streamController = StreamController<List<Map<String, dynamic>>>();
    _streamController.add(_items);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _addItem(String itemText) {
    _items.add({'text': itemText, 'completed': false});
    _streamController.add(_items);
  }

  void _toggleItemCompletion(int index) {
    _items[index]['completed'] = !_items[index]['completed'];
    _streamController.add(_items);
  }

  void _deleteItem(int index) {
    _items.removeAt(index);
    _streamController.add(_items);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista con Streams'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Nuevo Item',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  _addItem(_textController.text);
                  _textController.clear();
                }
              },
              child: const Text('Agregar Item'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay items en la lista.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        snapshot.data![index]['text'],
                        style: TextStyle(
                          decoration: snapshot.data![index]['completed']
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _toggleItemCompletion(index),
                            icon: Icon(snapshot.data![index]['completed']
                                ? Icons.check_box
                                : Icons.check_box_outline_blank),
                          ),
                          IconButton(
                            onPressed: () => _deleteItem(index),
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
