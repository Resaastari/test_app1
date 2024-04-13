import 'package:flutter/material.dart';
import 'package:test_app1/home_screen.dart';

class ListDataScreen extends StatefulWidget {
  const ListDataScreen({Key? key}) : super(key: key);

  @override
  _ListDataScreenState createState() => _ListDataScreenState();
}

class _ListDataScreenState extends State<ListDataScreen> {
  List<String> dataList = ['Item 1', 'Item 2', 'Item 3']; // Data list awal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resa Astari_2215091018'),
      ),
      body: ListView.builder(
        itemCount:
            dataList.length * 2 - 1, // Menambahkan divider di antara item
        itemBuilder: (context, index) {
          if (index.isOdd)
            return Divider(
                color:
                    Colors.blueGrey); // Memisahkan item dengan divider berwarna
          final itemIndex = index ~/ 2;
          return Column(
            children: [
              Container(
                color: Colors.blue, // Memberikan warna biru pada header
                height: 20, // Menyesuaikan tinggi header
              ),
              ListTile(
                title: Text(dataList[itemIndex]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editItem(itemIndex);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _confirmDelete(context, itemIndex);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                  color: Colors.blueGrey), // Menambahkan divider di antara item
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }

  // Fungsi untuk menambahkan item baru
  void _addItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newItem = '';
        return AlertDialog(
          title: Text('Add Item'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  dataList.add(newItem);
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengedit item
  void _editItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedItem = dataList[index];
        return AlertDialog(
          title: Text('Edit Item'),
          content: TextField(
            onChanged: (value) {
              editedItem = value;
            },
            controller: TextEditingController()..text = dataList[index],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  dataList[index] = editedItem;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus item
  void _deleteItem(int index) {
    setState(() {
      dataList.removeAt(index);
    });
    Navigator.of(context).pop(); // Tutup dialog konfirmasi setelah item dihapus
  }

  // Fungsi untuk menampilkan dialog konfirmasi sebelum menghapus item
  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteItem(index);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
