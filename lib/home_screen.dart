import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_app1/screens/news_screen.dart';
import 'package:test_app1/screens/crud.dart';
import 'package:test_app1/profile/profile_screen.dart';
import 'database_helper.dart';
import 'note_model.dart';
import 'create_note_screen.dart';
import 'note_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  late Future<List<Note>> _notesFuture;
  late TextEditingController _searchController;
  late List<Note> _notes = [];
  late List<Note> _searchResult = [];
  late File? _imageFile; // Tambahkan variabel _imageFile

  // Tambahkan path gambar latar belakang
  final String backgroundImage = 'assets/icon2.png';

  @override
  void initState() {
    super.initState();
    _notesFuture = dbHelper.getNotes();
    _searchController = TextEditingController();
    _imageFile = null; // Inisialisasi _imageFile dengan null
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _notesFuture = dbHelper.getNotes();
    });
  }

  Future<void> _deleteNoteAndRefreshList(int noteId) async {
    await dbHelper.deleteNote(noteId);
    _refreshNotes();
  }

  void _performSearch(String query) {
    _searchResult.clear();
    if (query.isNotEmpty) {
      _notes.forEach((note) {
        if (note.title.toLowerCase().contains(query.toLowerCase())) {
          _searchResult.add(note);
        }
      });
      setState(() {
        _searchResult;
      });
    } else {
      setState(() {
        _searchResult.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notepad'),
        centerTitle: true,
        backgroundColor: Colors.blue, // Warna biru untuk app bar
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Info Aplikasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Versi 1.0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Tentang Saya'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Tentang Saya'),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Pengembang: Resa Astari'),
                          Text('Email: Resatarigan19@gmail.com'),
                          Text('Alamat: Sumatra Utara, Indonesia'),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Tutup'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Berita'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsScreen()),
                );
              },
            ),
            // Menambahkan menu untuk navigasi ke List Data Screen
            ListTile(
              title:
                  const Text('List Data'), // Ganti dengan nama_alias kelas Anda
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListDataScreen()),
                );
              },
            ),
          ],
        ),
      ),
      // Gunakan Stack untuk menempatkan latar belakang dan konten di atasnya
      body: Stack(
        children: [
          // Latar belakang gambar
          Image.asset(
            backgroundImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Konten di atas gambar
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Cari Catatan',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) {
                      _performSearch(query);
                    },
                  ),
                ),
                FutureBuilder<List<Note>>(
                  future: _notesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final notes = snapshot.data;
                      _notes = notes ?? [];
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _searchResult.isNotEmpty
                            ? _searchResult.length
                            : _notes.length,
                        itemBuilder: (context, index) {
                          final note = _searchResult.isNotEmpty
                              ? _searchResult[index]
                              : _notes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: ListTile(
                              title: Text(note.title),
                              subtitle: Text(
                                note.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NoteDetailScreen(note: note),
                                  ),
                                );
                              },
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi'),
                                      content: const Text(
                                          'Apakah Anda yakin ingin menghapus catatan ini?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _deleteNoteAndRefreshList(note.id!);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Catatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        backgroundColor: Color.fromARGB(255, 117, 73,
            212), // Ubah warna latar belakang bottom navigation menjadi biru
        onTap: (int index) {
          switch (index) {
            case 0:
              // Navigasi ke layar catatan
              break;
            case 1:
              // Navigasi ke layar profil dengan menyertakan _imageFile
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(initialImageFile: _imageFile)),
              );
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateNoteScreen()),
          ).then((shouldRefresh) {
            if (shouldRefresh == true) {
              // Panggil method untuk memperbarui kalender di HomeScreen
              _refreshNotes();
            }
          });
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
