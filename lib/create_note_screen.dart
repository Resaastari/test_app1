import 'package:flutter/material.dart'; // Import package flutter untuk pengembangan UI
import 'database_helper.dart'; // Import file database_helper.dart untuk mengelola database
import 'note_model.dart'; // Import file note_model.dart untuk mendefinisikan model catatan

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final dbHelper = DatabaseHelper();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Catatan Baru'),
      ),
      body: Container(
        color: Colors.blue, // Background color biru
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Judul', // Label untuk judul
                style: TextStyle(
                  color: Colors.white, // Warna teks putih
                  fontSize: 18, // Ukuran teks 18
                  fontWeight: FontWeight.bold, // Tebal teks
                ),
              ),
              const SizedBox(height: 8), // Spasi antara judul dan TextField
              TextField(
                controller: _titleController,
                style: TextStyle(
                    color: Colors.white), // Warna teks putih pada input judul
                decoration: InputDecoration(
                  hintText: 'Masukkan judul catatan',
                  hintStyle:
                      TextStyle(color: Colors.white70), // Warna teks hint putih
                  filled: true,
                  fillColor: Colors.black
                      .withOpacity(0.3), // Warna latar belakang input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none, // Sembunyikan garis tepi input
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Isi Catatan', // Label untuk isi catatan
                style: TextStyle(
                  color: Colors.white, // Warna teks putih
                  fontSize: 18, // Ukuran teks 18
                  fontWeight: FontWeight.bold, // Tebal teks
                ),
              ),
              const SizedBox(height: 8), // Spasi antara label dan TextField
              TextField(
                controller: _contentController,
                style: TextStyle(
                    color: Colors
                        .white), // Warna teks putih pada input isi catatan
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Masukkan isi catatan',
                  hintStyle:
                      TextStyle(color: Colors.white70), // Warna teks hint putih
                  filled: true,
                  fillColor: Colors.black
                      .withOpacity(0.3), // Warna latar belakang input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none, // Sembunyikan garis tepi input
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveNote();
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      final note = Note(
        title: title,
        content: content,
        timestamp: '',
      );
      dbHelper.insertNote(note).then((_) {
        setState(() {});
        Navigator.pop(context);
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Peringatan'),
            content: const Text('Judul dan isi catatan tidak boleh kosong.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
