import 'package:flutter/material.dart';
import 'note_model.dart';
import 'database_helper.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final dbHelper = DatabaseHelper();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai awal judul dan isi catatan dari objek Note yang diterima
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    // Hapus controller saat widget di dispose untuk mencegah memory leaks
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveChangesAndNavigateBack(context);
            },
          ),
        ],
      ),
      // Menggunakan Stack untuk menempatkan latar belakang gambar
      body: Stack(
        children: [
          // Latar belakang gambar
          Image.asset(
            'assets/icon2.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Konten di atas gambar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contentController,
                  style: const TextStyle(fontSize: 16),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Isi Catatan',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menyimpan perubahan dan menutup halaman
  void _saveChangesAndNavigateBack(BuildContext context) async {
    final title = _titleController.text;
    final content = _contentController.text;

    // Periksa apakah judul dan isi catatan tidak kosong
    if (title.isNotEmpty && content.isNotEmpty) {
      // Update properti title dan content pada objek Note yang diterima
      widget.note.title = title;
      widget.note.content = content;
      // Panggil method updateNote dari dbHelper untuk menyimpan perubahan ke database
      await dbHelper.updateNote(widget.note);

      // Tampilkan snackbar sebagai indikasi perubahan disimpan
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Perubahan disimpan'),
        duration: Duration(seconds: 2),
      ));
      // Kembali ke home screen setelah pengeditan disimpan
      Navigator.pop(context, true);
    } else {
      // Tampilkan pesan error jika judul atau isi catatan kosong
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
